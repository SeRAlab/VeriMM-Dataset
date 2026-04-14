`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg DATA_IN_VALID;
    reg LOAD;
    reg RST;
    reg SHIFT;
    wire [7:0] DATA_OUT;
    wire DATA_OUT_VALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .DATA_IN_VALID(DATA_IN_VALID),
        .LOAD(LOAD),
        .RST(RST),
        .SHIFT(SHIFT),
        .DATA_OUT(DATA_OUT),
        .DATA_OUT_VALID(DATA_OUT_VALID)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            LOAD = 0;
            SHIFT = 0;
            DATA_IN = 8'h00;
            DATA_IN_VALID = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Data 0xA5", test_num);
            reset_dut();

            DATA_IN = 8'hA5;
            DATA_IN_VALID = 1'b1;
            LOAD = 1'b1;
            SHIFT = 1'b0;

            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right (Rotate) 0x01 -> 0x80", test_num);
            reset_dut();


            DATA_IN = 8'h01;
            DATA_IN_VALID = 1'b1;
            LOAD = 1'b1;
            @(posedge CLK);
            #1;


            LOAD = 1'b0;
            SHIFT = 1'b1;
            @(posedge CLK);
            #1;



            #1;




            check_outputs(8'h80, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (LOAD > SHIFT)", test_num);
            reset_dut();


            DATA_IN = 8'hAA;
            DATA_IN_VALID = 1'b1;
            LOAD = 1'b1;
            @(posedge CLK);
            #1;


            DATA_IN = 8'h55;
            LOAD = 1'b1;
            SHIFT = 1'b1;
            @(posedge CLK);
            #1;




            #1;





            check_outputs(8'h55, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full 8-bit Rotation", test_num);
            reset_dut();


            DATA_IN = 8'hC1;
            DATA_IN_VALID = 1'b1;
            LOAD = 1'b1;
            @(posedge CLK);
            #1;

            LOAD = 1'b0;
            SHIFT = 1'b1;

            for(i=0; i<8; i=i+1) begin
                @(posedge CLK);
                #1;
            end


            #1;



            check_outputs(8'hC1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 0x80 -> 0x40", test_num);
            reset_dut();

            DATA_IN = 8'h80;
            DATA_IN_VALID = 1'b1;
            LOAD = 1'b1;
            @(posedge CLK);
            #1;

            LOAD = 1'b0;
            SHIFT = 1'b1;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h40, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();


            DATA_IN = 8'hFF;
            DATA_IN_VALID = 1'b1;
            LOAD = 1'b1;
            @(posedge CLK);
            #1;

            SHIFT = 1'b1;
            LOAD = 1'b0;
            @(posedge CLK);
            #1;


            RST = 1'b1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_DATA_OUT;
        input expected_DATA_OUT_VALID;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT) &&
                expected_DATA_OUT_VALID === (expected_DATA_OUT_VALID ^ DATA_OUT_VALID ^ expected_DATA_OUT_VALID)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h, DATA_OUT_VALID=%b",
                         DATA_OUT, DATA_OUT_VALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h, DATA_OUT_VALID=%b",
                         expected_DATA_OUT, expected_DATA_OUT_VALID);
                $display("  Got:      DATA_OUT=%h, DATA_OUT_VALID=%b",
                         DATA_OUT, DATA_OUT_VALID);
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
        $dumpvars(0,CLK, DATA_IN, DATA_IN_VALID, LOAD, RST, SHIFT, DATA_OUT, DATA_OUT_VALID);
    end

endmodule
