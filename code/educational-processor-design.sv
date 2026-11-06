// Educational Processor — Portfolio Display Copy
// Author: Avash Aryal
// Course starter structure adapted and extended for this project.
// Updated for portfolio: November 2026
// Executable statements are preserved; comments were clarified for public presentation.

// This i s a header file that contains the parameters used in the entire project

// module adresses
parameter logic [3:0] MainMemEn = 0;
parameter logic [3:0] RegisterEn = 1;
parameter logic [3:0] InstrMemEn = 2;
parameter logic [3:0] AluEn = 3;
parameter logic [3:0] ExecuteEn = 4;
parameter logic [3:0] IntAlu = 5;

// Alu Register setup // same register sequence for both ALU's
parameter AluStatusIn = 0;
parameter AluStatusOut = 1;
parameter ALU_Source1 = 2;
parameter ALU_Source2 = 3;
parameter  ALU_Result = 4;
parameter Overflow_err = 5;

// opcodes
parameter MMult1 = 0;
parameter MMult2 = 1;
parameter MMult3 = 2;
parameter MAdd = 3;
parameter MSub = 4;
parameter MTranspose = 5;
parameter MScale = 6;
parameter MScaleImm = 7;
parameter Iadd = 8'h10;
parameter Isub = 8'h11;
parameter Imult = 8'h12;
parameter Idiv = 8'h13;
parameter BNE=8'h20;
parameter BEQ = 8'h21;
parameter BLT = 8'h22;
parameter BGT=8'h23;

// Instructions
// add the data at location 0 to the data at location 1 and place result in location 2

parameter Instruct1 = 32'h 03_02_00_01; // add first matrix to second matrix store in memory

parameter Instruct2 = 32'h 06_03_00_0a; // scale matrix 1 by whats in location A store in memory

parameter Instruct3 = 32'h 10_10_0a_0b; // add 16 bit numbers in location a to b store in temp register

parameter Instruct4 = 32'h 04_04_03_00; //Subtract the first matrix from the result in step 2 and store the result somewhere else in memory.

parameter Instruct5 = 32'h 22_01_04_03;//IF mem04 < mem03 goto 7 (Step 7 would be the next step)


parameter Instruct6 = 32'h 05_05_02_00;//Transpose the result from step 1 store in memory

parameter Instruct7 = 32'h 21_81_08_05;// IF mem 4 !- mem 8 goto step 6


parameter Instruct8 = 32'h 07_11_03_08;//ScaleImm the result in step 2 by the result from step 3 store in a matrix register

parameter Instruct9 = 32'h 00_06_04_05; //Multiply the result from step 4 by the result in step 5, store in memory. 4x4 * 4x4


parameter Instruct10 = 32'h 12_0a_01_00;//Multiply the integer value in memory location 0 to location 1. Store it in memory location 0x0A

parameter Instruct11 = 32'h 11_12_0a_01;//Subtract the integer value in memory location 01 from memory location 0x0A and store it in a register

parameter Instruct12 = 32'h 13_0c_12_0a;//Divide the result from step 8 by the result in step 9  and store it in location 0x0B

parameter Instruct13 = 32'h FF_00_00_00; // stop





// Instruction memory.
// holds the instructions that the processor will execute.
//
// the address lines are generic and each module must handle thier own decode.
// The address bus is large enough that each module can contain a local address decode. This will save on multiple enmables.
// bit 11-0 are for adressing inside each unit.
// nWrite = 0 means databus is being written into the part on the falling edge of write
// nRead = 0 means it is expected to drive the databus while this signal is low and the address is correct until the nRead goes high independent of addressd bus.



//parameter MainMemEn = 0;
//parameter RegisterEn = 1;
//parameter InstrMemEn = 2;
//parameter AluEn = 3;
//parameter ExecuteEn = 4;
//parameter IntAlu = 5;

// Alu Register setup // same register sequence for both ALU's
//parameter AluStatusIn = 0;
//parameter AluStatusOut = 1;
//parameter ALU_Source1 = 2;
//parameter ALU_Source2 = 3;
//parameter  ALU_Result = 4;
//parameter Overflow_err = 5;

//////////////////////////////
//Moved stop to third instruction for this example
/////////////////////////////////////////////////
// instruction: OPcode :: dest :: src1 :: src2 Each section is 8 bits.
//Stop::FFh::00::00::00
//MMult1::00h::Reg/mem::Reg/mem::Reg/mem
//MMult2::01h::Reg/mem::Reg/mem::Reg/mem
//MMult3::02h::Reg/mem::Reg/mem::Reg/mem
//Madd::03h::Reg/mem::Reg/mem::Reg/mem
//Msub::04h::Reg/mem::Reg/mem::Reg/mem
//Mtranspose::05h::Reg/mem::Reg/mem::Reg/mem
//MScale::06h::Reg/mem::Reg/mem::Reg/mem
//MScaleImm::07h:Reg/mem::Reg/mem::Immediate
//IntAdd::10h::Reg/mem::Reg/mem::Reg/mem
//IntSub::11h::Reg/mem::Reg/mem::Reg/mem
//IntMult::12h::Reg/mem::Reg/mem::Reg/mem
//IntDiv::13h::Reg/mem::Reg/mem::Reg/mem


// Read-only instruction storage and bus interface.
module InstructionMemory(Clk,Dataout, address, nRead,nReset);
// NOTE the lack of datain and write. This is because this is a ROM model



input logic nRead, nReset, Clk;
input logic [15:0] address;

inout logic [31:0] Dataout; // 1 - 32 it instructions at a time.

  logic [31:0]InstructMemory[15]; // this is the physical memory
  logic ItsMe; // the address bus is talkig to this module. used to enable tristate buffers.
  logic [31:0] InstToOutput; // this is a temporary data register to be set to go to the output.
// This memory is designed to be driven into a data multiplexor.

  always_ff @(negedge Clk or negedge nReset)
begin
  if (!nReset)
    InstToOutput = 0;
  else begin
  if(address[15:12] == InstrMemEn) // talking to Instruction IntstrMemEn
		begin
		    ItsMe = 1;
			if(~nRead)begin
				InstToOutput <= InstructMemory[address[11:0]]; // data will reamin on dataout until it is changed.
			end
		end
	else ItsMe = 0;
	end
end // from negedge nRead

always @(negedge nReset)
begin
//	set in the default instructions
//
	InstructMemory[0] = Instruct1;
	InstructMemory[1] = Instruct2;
  	InstructMemory[2] = Instruct3;
	InstructMemory[3] = Instruct4;
	InstructMemory[4] = Instruct5;
	InstructMemory[5] = Instruct6;
	InstructMemory[6] = Instruct7;
	InstructMemory[7] = Instruct8;
	InstructMemory[8] = Instruct9;
	InstructMemory[9] = Instruct10;
	InstructMemory[10] = Instruct11;
	InstructMemory[11] = Instruct12;
	InstructMemory[12] = Instruct13;
end

assign Dataout = ItsMe ? InstToOutput : 32'bz;



endmodule


//
//



// Read/write data memory connected to the shared processor bus.
module MainMemory(Clk,Dataout, address, nRead,nWrite, nReset);



input logic nRead,nWrite, nReset, Clk;
input logic [15:0] address;

inout logic [255:0] Dataout; // to the CPU

  logic [255:0]MainMemory[14]; // this is the physical memory
  logic ItsMe; // the address bus is talkig to this module. used to enable tristate buffers.
  logic [255:0] MemToOutput; // this is a temporary data register to be set to go to the output.

always_ff @(negedge Clk or negedge nReset)
begin
	if (~nReset) begin
	MainMemory[0] = 256'h000f_000c_0008_000d_0008_0010_000f_0009_000b_0008_0006_0007_000c_0005_000c_0008;
      MainMemory[1] = 256'h000a_0005_0007_0009_000b_0004_000e_0002_0007_0006_0007_0008_000c_0007_0004_0009;
	MainMemory[2] = 256'h0;
	MainMemory[3] = 256'h0;
	MainMemory[4] = 256'h0;
	MainMemory[5] = 256'h0;
	MainMemory[6] = 256'h0;
	MainMemory[7] = 256'h0;
	MainMemory[8] = 256'h0;
	MainMemory[9] = 256'h0;
      MainMemory[10] = 256'h03;
      MainMemory[11] = 256'h0c;
	MainMemory[12] = 256'h0;
	MainMemory[13] = 256'h0;


      MemToOutput=0;
	end

  else if(address[15:12] == MainMemEn) // talking to Instruction
		begin

			if (~nRead)begin
			  ItsMe = 1; // Only Drive Bus on read
				MemToOutput = MainMemory[address[11:0]]; // data will remain on dataout until it is changed.
			end
			if(~nWrite)begin
			ItsMe = 0; // only drive bus on read
		    MainMemory[address[11:0]] <= Dataout;
			end
		end
    else ItsMe = 0;
end

assign Dataout = ItsMe ? MemToOutput : 256'bz;
endmodule

/////////////////////////////////////
//Matrix Calculations
/////////////////////////////////////
// Matrix datapath for add, subtract, transpose, scale, and multiply operations.
module MatrixAlu(Clk,DataOut, address, nRead,nWrite, nReset);

  input logic nRead,nWrite, nReset, Clk;
  input logic [15:0] address;

  inout logic [255:0] DataOut;
  logic [15:0] matrices [0:1][0:3][0:3];

  logic ItsMe;
  logic [255:0] MatrixToOutput;

  logic [33:0] sum;

  always_ff @(negedge Clk or negedge nReset)
    begin
      if(!nReset)
        begin
          matrices <= '{default:'0};
          ItsMe<=0;
        end
      else if(address[15:12] == AluEn)
        begin
          ItsMe<=0;
          if (~nWrite)
            begin
              for (int i = 0; i < 4; i = i + 1)
    		    begin
        			for (int j = 0; j < 4; j = j + 1)
        			begin
                      matrices[address[3:0]][i][j] <= DataOut[((i*4+j)*16) +: 16];
        			end
    			end
            end
          if(~nRead)
            begin
                if(address[11:4] == MAdd)
                begin
                    for(int i = 0; i < 4; i = i + 1)
                    begin
                        for(int j = 0; j < 4; j = j + 1)
                        begin
                            MatrixToOutput[((i*4+j)*16) +: 16]
                                <= matrices[0][i][j]
                                 + matrices[1][i][j];
                        end
                    end
                end
              if(address[11:4] == MSub)
                begin
                    for(int i = 0; i < 4; i = i + 1)
                    begin
                        for(int j = 0; j < 4; j = j + 1)
                        begin
                            MatrixToOutput[((i*4+j)*16) +: 16]
                                <= matrices[0][i][j]
                                 - matrices[1][i][j];
                        end
                    end
                end
              if(address[11:4] == MTranspose)
                begin
                    for(int i = 0; i < 4; i = i + 1)
                    begin
                        for(int j = 0; j < 4; j = j + 1)
                        begin
                            MatrixToOutput[((i*4+j)*16) +: 16]
                                     <= matrices[0][j][i];
                        end
                    end
                end
              if(address[11:4] == MScale)
                begin
                    for(int i = 0; i < 4; i = i + 1)
                    begin
                        for(int j = 0; j < 4; j = j + 1)
                        begin
                            MatrixToOutput[((i*4+j)*16) +: 16]
                                <= matrices[0][i][j]
                                 * matrices[1][0][0];
                        end
                    end
                end
              if(address[11:4] == MScaleImm)
                begin
                    for(int i = 0; i < 4; i = i + 1)
                    begin
                        for(int j = 0; j < 4; j = j + 1)
                        begin
                            MatrixToOutput[((i*4+j)*16) +: 16]
                                <= matrices[0][i][j]
                         		 * matrices[1][0][0];
                        end
                    end
                end
              if(address[11:4] == MMult1)
                begin
                    for(int i = 0; i < 4; i = i + 1)
                    begin
                        for(int j = 0; j < 4; j = j + 1)
                        begin
                          sum=0;
                          for(int k=0; k<4; k++)
                            begin
                              sum+=matrices[0][i][k]*matrices[1][k][j];
                            end
                            MatrixToOutput[((i*4+j)*16) +: 16]
                          <= sum[15:0];
                        end
                    end
                end

                ItsMe <= 1;
            end
        end
       else
        ItsMe<=0;
    end


  assign DataOut= ItsMe ? MatrixToOutput : 256'bz;

endmodule


//////////////////////////////////////
//Execution Engine
/////////////////////////////////////
// Fetch/decode control, internal registers, branch handling, and datapath sequencing.
module Execution(Clk,DataOut, address, nRead,nWrite, nReset);
  output logic nRead,nWrite;
  input logic nReset, Clk;
  output logic [15:0] address;

  inout logic [255:0] DataOut;

  logic [255:0] InternalReg[3:0];
  logic ItsMe, InsMemRead;

  logic [255:0] MatrixToOutput;

  logic [2:0] State;
  logic [11:0] count;
  logic [2:0] AluStatus;

  logic [7:0] OpCode;
  logic [7:0] Destination;
  logic [7:0] Source1;
  logic [7:0] Source2;

  logic [255:0] registersForBranch [0:1];
  logic BranchEn;


  always_ff @(posedge Clk or negedge nReset)
    begin
      if(~nReset)
        begin

          address<=0;
          registersForBranch <= '{default:'0};
          BranchEn<=0;
          nRead<=1;
          nWrite<=1;
          State<=InstrMemEn;
          count<=0;
          InsMemRead<=0;
          OpCode<=0;
          Source2<=0;
          Source1<=0;
          Destination<=0;
        end


////////For Branching
      else if(BranchEn)
        begin
          if(OpCode==BNE)
            begin
              if(registersForBranch[0]!=registersForBranch[1])
                begin
                  if(Destination[7:4]==4'h0)
                    begin
                      count <= count + Destination[6:0];
                    end
                  else
                    begin
                      count <= count - Destination[6:0] - 1;
                    end
                end
            end
          else if(OpCode==BEQ)
            begin
              if(registersForBranch[0]==registersForBranch[1])
                begin
                  if(Destination[7:4]==4'h0)
                    begin
                      count <= count + Destination[6:0];
                    end
                  else
                    begin
                      count <= count - Destination[6:0] - 1;
                    end
                end
            end
          else if(OpCode==BLT)
            begin
              if(registersForBranch[0]<registersForBranch[1])
                begin
                  if(Destination[7:4]==4'h0)
                    begin
                      count <= count + Destination[6:0];
                    end
                  else
                    begin
                      count <= count - Destination[6:0] - 1;
                    end
                end
            end
          else if(OpCode==BGT)
            begin
              if(registersForBranch[0]>registersForBranch[1])
                begin
                  if(Destination[7:4]==4'h0)
                    begin
                      count <= count + Destination[6:0];
                    end
                  else
                    begin
                      count <= count - Destination[6:0] - 1;
                    end
                end
            end
          State<=InstrMemEn;
          nRead<=1;
          nWrite<=1;
          BranchEn<=0;
        end


//////For Operation
      else if(OpCode!=8'hff)
        begin
          nRead<=1;
      	  nWrite<=1;


          case (State)
            InstrMemEn:
              begin
              address <= {InstrMemEn, count};
			  count <= count + 1;
              nRead<=0;
              State<=MainMemEn;
              AluStatus<=ALU_Source1;
              InsMemRead<=1;
              end
//////////////MainMemEn
            MainMemEn:
              begin
              if(InsMemRead==1)
           		 begin
              	 OpCode      <= DataOut[31:24];
			  	 Destination <= DataOut[23:16];
			  	 Source1     <= DataOut[15:8];
			  	 Source2     <= DataOut[7:0];
              	 InsMemRead<=0;
                 end
               else if(AluStatus==ALU_Source1)
                  begin
                    if(Source1[7:4]==4'h0)
                      begin
                    	address<={MainMemEn,4'h0, Source1};
                    	nRead<=0;
                    	State<=AluEn;

                      end
                    else if(Source1[7:4]==4'h1)
                      begin
                        if(OpCode[7:4]==4'h2)
                          begin
                            registersForBranch[0]<=InternalReg[Source1[3:0]];
                            AluStatus<=ALU_Source2;
                          end
                        else
                          begin
                        	address<={ExecuteEn,8'h0, Source1[3:0]};
                    		nRead<=0;
                    		State<=AluEn;
                          end
                      end
                  end
                else if(AluStatus==ALU_Source2)
                  begin
                    if(OpCode==8'h07)
                      begin
                        address<={ExecuteEn,4'h0,Source2};
                        nRead<=0;
                        State<=AluEn;
                      end
                    else if(Source2[7:4]==4'h0)
                      begin
                    	address<={MainMemEn,4'h0, Source2};
                    	nRead<=0;
                    	State<=AluEn;
                      end
                    else if(Source2[7:4]==4'h1)
                      begin
                        if(OpCode[7:4]==4'h2)
                          begin
                            registersForBranch[1]<=InternalReg[Source2[3:0]];
                            BranchEn<=1;
                            AluStatus<=ALU_Source1;
                          end
                        else
                          begin
                        	address<={ExecuteEn,8'h0,Source2[3:0]};
                       		nRead<=0;
                        	State<=AluEn;
                          end
                      end
                  end
                else if(AluStatus==ALU_Result)
                  begin
                    if(Destination[7:4]==4'h0)
                      begin
                    	address<={MainMemEn,4'h0, Destination};
                    	nWrite<=0;
                    	State<=InstrMemEn;
                      end
                    else if(Destination[7:4]==4'h1)
                      begin
                        address<={ExecuteEn,8'h0, Destination[3:0]};
                        nWrite<=0;
                        State<=InstrMemEn;
                      end
                  end
              end
//////////////Alu En
            AluEn:
              begin
                //for matirx
                if(OpCode[7:4]==4'h0)
                  begin
                	if(AluStatus==ALU_Source1)
                  	begin
                        begin
                    		address<={AluEn, OpCode, 4'h0};
                    		nWrite<=0;
                    		AluStatus<=ALU_Source2;
                    		State<=MainMemEn;
                        end
                  	end
                	else if(AluStatus==ALU_Source2)
                  	begin
                        begin
                    		address<={AluEn, OpCode,4'h1};
                    		nWrite<=0;
                    		AluStatus<=ALU_Result;
                        end
                  	end
                	else if(AluStatus==ALU_Result)
                  	begin
                    	address<={AluEn, OpCode, 4'h0};
                    	nRead<=0;
                    	State<=MainMemEn;
                  	end
                  end

                //FOR Branching
                else if(OpCode[7:4]==4'h2)
                  begin
                    if(AluStatus==ALU_Source1)
                      begin
                        registersForBranch[0]<=DataOut;
                        AluStatus<=ALU_Source2;
                        State<=MainMemEn;
                      end
                    else if(AluStatus==ALU_Source2)
                      begin
                        registersForBranch[1]<=DataOut;
                        AluStatus<=ALU_Source2;
                        State<=InstrMemEn;
                        BranchEn<=1;
                      end
                  end

                 //for int
                else if(OpCode[7:4]==4'h1)
                   begin
                     if(AluStatus==ALU_Source1)
                  	begin
                      address<={IntAlu, OpCode, 4'h0};
                    	nWrite<=0;
                    	AluStatus<=ALU_Source2;
                    	State<=MainMemEn;
                  	end
                	else if(AluStatus==ALU_Source2)
                  	begin
                      address<={IntAlu, OpCode,4'h1};
                      nWrite<=0;
                      AluStatus<=ALU_Result;
                  	end
                	else if(AluStatus==ALU_Result)
                  	begin
                      address<={IntAlu, OpCode, 4'h0};
                    	nRead<=0;
                    	State<=MainMemEn;
                  	end
                   end
              end
          endcase
        end
      else
        begin
          State<=InstrMemEn;
          nRead<=1;
          nWrite<=1;
        end
    end

  always_ff @(negedge Clk or negedge nReset)
begin
	if (~nReset) begin
	 InternalReg<='{default:'0};
     MatrixToOutput<='{default:'0};
      ItsMe<=0;
	end

  else if(address[15:12] == ExecuteEn) // talking to Instruction
		begin

			if (~nRead)begin
			  ItsMe = 1; // Only Drive Bus on read
              if(OpCode==8'h07 && AluStatus==ALU_Source2)
                begin
                  MatrixToOutput={244'h0,address[11:0]};
                end
              else
                begin
					MatrixToOutput = InternalReg[address[11:0]]; // data will 							remain on dataout until it is changed.
                end
			end
			if(~nWrite)begin
			ItsMe = 0; // only drive bus on read
              InternalReg[address[11:0]] <= DataOut;
			end
		end
    else ItsMe = 0;
end



 assign DataOut=ItsMe? MatrixToOutput : 256'bz;
endmodule




////////////////////////////
//////// Integer Operation
////////////////////////////

// Integer arithmetic datapath for add, subtract, multiply, and guarded divide.
module IntegerAlu(Clk,DataOut, address, nRead,nWrite, nReset);
  input logic nRead,nWrite, nReset, Clk;
  input logic [15:0] address;

  logic ItsMe;

  inout logic [255:0] DataOut;

  logic [255:0] integers [0:1];

  logic [255:0] IntToOutput;

  always_ff @(negedge Clk or negedge nReset)
    begin
      if(!nReset)
        begin
          integers <= '{default:'0};
          ItsMe<=0;
        end
      else if(address[15:12] == IntAlu)
        begin
          ItsMe<=0;
          if (~nWrite)
            begin
              integers[address[3:0]]<= DataOut;
            end
          if(~nRead)
            begin
              if(address[11:4] == Iadd)
                begin
                  IntToOutput<= {240'b0,
                    			integers[0][15:0] + integers[1][15:0]};
                end
              if(address[11:4] == Isub)
                begin
                  IntToOutput<= {240'b0,
                    			integers[0][15:0] - integers[1][15:0]};
                end
              if(address[11:4] == Imult)
                begin
                  IntToOutput<= {240'b0,
                    			integers[0][15:0] * integers[1][15:0]};
                end
              if(address[11:4] == Idiv)
                begin
                  if(integers[1][15:0] == 16'h0000)
        			IntToOutput <= 256'h0;
    			  else
        			IntToOutput <= {240'b0,
                        			integers[0][15:0] / integers[1][15:0]};
                 end

                ItsMe <= 1;
            end
        end
       else
        ItsMe<=0;
    end


  assign DataOut= ItsMe ? IntToOutput : 256'bz;

endmodule
