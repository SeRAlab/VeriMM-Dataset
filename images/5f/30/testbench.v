`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [2:0] COL;
    reg RESET;
    wire [7:0] DEBUG;
    wire OPEN;
    wire [3:0] ROW;
    wire [255:0] W;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .COL(COL),
        .RESET(RESET),
        .DEBUG(DEBUG),
        .OPEN(OPEN),
        .ROW(ROW),
        .W(W)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: System Reset Verification", test_num);

        RESET = 1;
        COL = 3'b000;
        repeat(5) @(posedge CLK);

        RESET = 0;
        repeat(2) @(posedge CLK);



        #1;




        check_outputs(8'h00, 1'b0, 4'h0, 256'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Single Column Selection (COL 1)", test_num);

        RESET = 1; #10; RESET = 0;
        @(posedge CLK);

        COL = 3'b001;
        repeat(10) @(posedge CLK);



        #1;




        check_outputs(8'h01, 1'b1, 4'b0001, 256'hFFFF_FFFF_0000_0000_EEEE_EEEE_0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Alternative Column Selection (COL 4)", test_num);

        RESET = 1; #10; RESET = 0;
        @(posedge CLK);

        COL = 3'b100;
        repeat(10) @(posedge CLK);


        #1;



        check_outputs(8'h04, 1'b1, 4'b0100, 256'hAAAA_BBBB_CCCC_DDDD_0000_1111_2222_3333);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiple Column Bits Active", test_num);

        RESET = 1; #10; RESET = 0;
        @(posedge CLK);

        COL = 3'b111;
        repeat(15) @(posedge CLK);


        #1;



        check_outputs(8'h07, 1'b1, 4'b1111, 256'hF0F0_F0F0_F0F0_F0F0_AAAA_5555_CCCC_3333);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Boundary and Data Width Check", test_num);

        RESET = 1; #10; RESET = 0;
        @(posedge CLK);

        COL = 3'b010;
        repeat(5) @(posedge CLK);


        #1;



        check_outputs(8'h02, 1'b1, 4'b0010, {128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF, 128'h0});
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_DEBUG;
        input expected_OPEN;
        input [3:0] expected_ROW;
        input [255:0] expected_W;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DEBUG === (expected_DEBUG ^ DEBUG ^ expected_DEBUG) &&
                expected_OPEN === (expected_OPEN ^ OPEN ^ expected_OPEN) &&
                expected_ROW === (expected_ROW ^ ROW ^ expected_ROW) &&
                expected_W === (expected_W ^ W ^ expected_W)) begin
                $display("PASS");
                $display("  Outputs: DEBUG=%h, OPEN=%b, ROW=%h, W=%h",
                         DEBUG, OPEN, ROW, W);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DEBUG=%h, OPEN=%b, ROW=%h, W=%h",
                         expected_DEBUG, expected_OPEN, expected_ROW, expected_W);
                $display("  Got:      DEBUG=%h, OPEN=%b, ROW=%h, W=%h",
                         DEBUG, OPEN, ROW, W);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
