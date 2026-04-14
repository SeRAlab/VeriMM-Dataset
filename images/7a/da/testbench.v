`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg LOAD;
    wire [7:0] Q;
    wire Q7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .Q(Q),
        .Q7(Q7)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 1;
            DATA_IN = 8'h00;
            @(posedge CLK);
            #1;
            LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Load 8'hFF", test_num);

            DATA_IN = 8'hFF;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;


            #1;



            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Load 8'h80 and shift once (Circular)", test_num);

            DATA_IN = 8'h80;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Load 8'hA5 and shift once", test_num);

            DATA_IN = 8'hA5;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h4B, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Load 8'h01 and shift 8 times", test_num);

            DATA_IN = 8'h01;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;

            for(i=0; i<8; i=i+1) begin
                @(posedge CLK);
                #1;
            end


            #1;



            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Load 8'h00 and shift", test_num);

            DATA_IN = 8'h00;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Load 8'h01 and shift 7 times", test_num);

            DATA_IN = 8'h01;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;

            for(i=0; i<7; i=i+1) begin
                @(posedge CLK);
                #1;
            end


            #1;



            check_outputs(8'h80, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Load, shift, load again", test_num);


            DATA_IN = 8'hAA;
            LOAD = 1;
            @(posedge CLK);
            #1;


            LOAD = 0;
            @(posedge CLK);
            #1;


            DATA_IN = 8'hCC;
            LOAD = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hCC, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Verify Q7 output with 8'h7F and 8'h80", test_num);

            DATA_IN = 8'h7F;
            LOAD = 1;
            @(posedge CLK);
            #1;

            if (Q7 === 1'b0) begin

                 DATA_IN = 8'h80;
                 LOAD = 1;
                 @(posedge CLK);
                 #1;
                 #1;

                 check_outputs(8'h80, 1'b1);
            end else begin
                 #1;

                 check_outputs(8'h80, 1'b1);
            end
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_Q;
        input expected_Q7;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q7 === (expected_Q7 ^ Q7 ^ expected_Q7)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Q7=%b",
                         Q, Q7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Q7=%b",
                         expected_Q, expected_Q7);
                $display("  Got:      Q=%h, Q7=%b",
                         Q, Q7);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, DATA_IN, LOAD, Q, Q7);
    end

endmodule
