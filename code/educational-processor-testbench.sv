// Educational Processor — Portfolio Display Copy
// Author: Avash Aryal
// Course starter structure adapted and extended for this project.
// Updated for portfolio: November 2026
// Executable statements are preserved; comments were clarified for public presentation.

// Educational processor simulation top module
//
// Main memory MUST be allocated in the mainmemory module as per teh next line.
//  logic [255:0]MainMemory[12]; // this is the physical memory
//



// Top-level simulation harness connecting memory, control, and ALU modules.
module top ();

wire [255:0] DataBus;
logic nRead,nWrite,nReset,Clk;
logic [15:0] address;

logic Fail;

InstructionMemory  U1(Clk,DataBus, address, nRead,nReset);

MainMemory  U2(Clk,DataBus, address, nRead,nWrite, nReset);

Execution  U3(Clk,DataBus, address, nRead,nWrite, nReset);

MatrixAlu  U4(Clk,DataBus, address, nRead,nWrite, nReset);

IntegerAlu  U5(Clk,DataBus, address, nRead,nWrite, nReset);

TestMatrix  UTest(Clk,nReset);

  initial begin //. setup to allow waveforms for edaplayground
   $dumpfile("dump.vcd");
   $dumpvars(1);
    Fail = 0; // SETUP TO PASS TO START
 end

always @(DataBus) begin // this block checks to make certain the proper data is in the memory.
		if (DataBus[31:0] == 32'hff000000)
// we are about to execute the stop
begin
// Print out the entire contents of main memory so I can copy and paste.
			$display ( "memory location 0 = %h", U2.MainMemory[0]);
			$display ( "memory location 1 = %h", U2.MainMemory[1]);
			$display ( "memory location 2 = %h", U2.MainMemory[2]);
			$display ( "memory location 3 = %h", U2.MainMemory[3]);
			$display ( "memory location 4 = %h", U2.MainMemory[4]);
			$display ( "memory location 5 = %h", U2.MainMemory[5]);
			$display ( "memory location 6 = %h", U2.MainMemory[6]);
			$display ( "memory location 7 = %h", U2.MainMemory[7]);
			$display ( "memory location 8 = %h", U2.MainMemory[8]);
			$display ( "memory location 9 = %h", U2.MainMemory[9]);
			$display ( "memory location 10 = %h", U2.MainMemory[10]);
			$display ( "memory location 11 = %h", U2.MainMemory[11]);
			$display ( "memory location 12 = %h", U2.MainMemory[12]);
			$display ( "memory location 13 = %h", U2.MainMemory[13]);

			$display ( "Imternal Reg location 0 = %h", U3.InternalReg[0]);
			$display ( "Internal reg location 1 = %h", U3.InternalReg[1]);
			$display ( "Internal reg location 2 = %h", U3.InternalReg[2]);
			$display ( "Internal reg location 3 = %h", U3.InternalReg[3]);

		if (U2.MainMemory[0] == 256'h000f000c0008000d00080010000f0009000b000800060007000c0005000c0008)
			$display ( "memory location 0 is Correct");
		else begin Fail = 1; $display ( "memory location 0 is Wrong"); end
		if (U2.MainMemory[1] == 256'h000a000500070009000b0004000e00020007000600070008000c000700040009)
			$display ( "memory location 1 is Correct");
		else begin Fail = 1;$display ( "memory location 1 is Wrong"); end
		if (U2.MainMemory[2] == 256'h00190011000f001600130014001d000b0012000e000d000f0018000c00100011)
			$display ( "memory location 2 is Correct");
		else begin Fail = 1;$display ( "memory location 2 is Wrong"); end
		if (U2.MainMemory[3] == 256'h002d00240018002700180030002d001b00210018001200150024000f00240018)
			$display ( "memory location 3 is Correct");
		else begin Fail = 1;$display ( "memory location 3 is Wrong"); end
		if (U2.MainMemory[4] == 256'h001e00180010001a00100020001e001200160010000c000e0018000a00180010)
			$display ( "memory location 4 is Correct");
		else begin Fail = 1;$display ( "memory location 4 is Wrong"); end
		if (U2.MainMemory[5] == 256'h001900130012001800110014000e000c000f001d000d00100016000b000f0011)
			$display ( "memory location 5 is Correct");
		else begin Fail = 1;$display ( "memory location 5 is Wrong"); end
		if (U2.MainMemory[6] == 256'h07b2070805c206aa06fe07dc05740612051e04d803da047e05ca05f804640548)
			$display ( "memory location 6 is Correct");
		else begin Fail = 1;$display ( "memory location 6 is Wrong"); end
		if (U2.MainMemory[7] == 256'h0000000000000000000000000000000000000000000000000000000000000000)
			$display ( "memory location 7 is Correct");
		else begin Fail = 1;$display ( "memory location 7 is Wrong"); end
		if (U2.MainMemory[8] == 256'h0000000000000000000000000000000000000000000000000000000000000000)
			$display ( "memory location 8 is Correct");
		else begin Fail = 1;$display ( "memory location 8 is Wrong"); end
		if (U2.MainMemory[9] == 256'h0000000000000000000000000000000000000000000000000000000000000000)
			$display ( "memory location 9 is Correct");
		else begin Fail = 1;$display ( "memory location 9 is Wrong"); end
		if (U2.MainMemory[10][15:0] == 16'h0048)
			$display ( "memory location 10 is Correct");
		else begin Fail = 1;$display ( "memory location 10 is Wrong"); end
		if (U2.MainMemory[11][15:0] == 16'h000c)
			$display ( "memory location 11 is Correct");
		else begin Fail = 1;$display ( "memory location 11 is Wrong"); end
		if (U2.MainMemory[12][15:0] == 16'h0000)
			$display ( "memory location 12 is Correct");
		else begin Fail = 1;$display ( "memory location 12 is Wrong"); end


		if (U3.InternalReg[0][15:0] == 16'h000f)
			$display ( "Interal reg location 0 is Correct");
		else begin Fail = 1; $display ( "Internal Register 0 is Wrong"); end
		if (U3.InternalReg[1] == 256'h0168012000c0013800c00180016800d8010800c0009000a801200078012000c0)
			$display ( "Internal Reg location 1 is Correct");
		else begin Fail = 1; $display ( "Internal Register 1 is Wrong"); end
		if (U3.InternalReg[2][15:0] == 16'h003f)
			$display ( "Internal Reg location 2 is Correct");
		else begin Fail = 1; $display ( "Internal Register 2 is Wrong"); end

        if (Fail) begin
        $display("********************************************");
        $display(" Project did not return the proper values");
        $display("********************************************");
        end
        else begin
        $display("********************************************");
        $display(" Project PASSED memory check");
        $display("********************************************");
        end

        end

end


endmodule









// Generic Test bench It drives only clock and reset.


// Testbench clock/reset generation and end-of-run memory reporting.
module TestMatrix  (Clk,nReset);

	output logic Clk,nReset; // we are driving these signals from here.

	initial begin
		Clk = 0;
		nReset = 1;
	#5 nReset = 0;
	#5 nReset = 1;
	end

	always  #5 Clk = ~Clk;


initial
begin
    #1200;

    $display("\n================================================");
	$display("          ALL MAIN MEMORY VALUES");
	$display("================================================");

	for (int i = 0; i < 14; i = i + 1)
	begin
    	$display("Memory[%0d] = %064h", i, $root.top.U2.MainMemory[i]);
	end

	$display("================================================\n");

    #10;
    $finish;
end

	endmodule
