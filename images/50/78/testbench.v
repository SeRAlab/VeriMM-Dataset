`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLKDIV;
    reg [7:0] DATA_IN;
    reg RST;
    wire [7:0] data_out;
    wire data_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLKDIV(CLKDIV),
        .DATA_IN(DATA_IN),
        .RST(RST),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    // Clock generation (10ns period)
    initial begin
        CLKDIV = 0;
        forever #5 CLKDIV = ~CLKDIV;
    end

        task reset_dut;

        begin
            RST = 1;
            DATA_IN = 8'h00;
            repeat(2) @(posedge CLKDIV);
            #1;
            RST = 0;
            @(posedge CLKDIV);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Basic Frame Reception", test_num);
            reset_dut();


            DATA_IN = 8'hF5; @(posedge CLKDIV);
            DATA_IN = 8'h1D; @(posedge CLKDIV);


            for (i = 1; i <= 28; i = i + 1) begin
                DATA_IN = i[7:0];
                if (i < 28) @(posedge CLKDIV);
            end


            #2;
            #1;

            check_outputs(8'h1C, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Header Recovery (Repeated F5)", test_num);
            reset_dut();

            DATA_IN = 8'hF5; @(posedge CLKDIV);
            DATA_IN = 8'hF5; @(posedge CLKDIV);
            DATA_IN = 8'h1D; @(posedge CLKDIV);


            for (i = 1; i <= 28; i = i + 1) begin
                DATA_IN = 8'hA0 + i[7:0];
                if (i < 28) @(posedge CLKDIV);
            end

            #2;
            #1;

            check_outputs(8'hA0 + 8'd28, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Post-frame IDLE state", test_num);
            reset_dut();

            DATA_IN = 8'hF5; @(posedge CLKDIV);
            DATA_IN = 8'h1D; @(posedge CLKDIV);

            for (i = 1; i <= 28; i = i + 1) begin
                DATA_IN = i[7:0];
                @(posedge CLKDIV);
            end


            DATA_IN = 8'hFF;
            #2;
            #1;

            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Invalid Header Sequence", test_num);
            reset_dut();

            DATA_IN = 8'hF5; @(posedge CLKDIV);
            DATA_IN = 8'hEE; @(posedge CLKDIV);


            DATA_IN = 8'hAA; @(posedge CLKDIV);

            #2;
            #1;

            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Reset mid-transmission", test_num);
            reset_dut();

            DATA_IN = 8'hF5; @(posedge CLKDIV);
            DATA_IN = 8'h1D; @(posedge CLKDIV);


            for (i = 1; i <= 10; i = i + 1) begin
                DATA_IN = i[7:0];
                @(posedge CLKDIV);
            end


            RST = 1;
            #2;
            #1;

            check_outputs(8'h00, 1'b0);
            RST = 0;
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
        input [7:0] expected_data_out;
        input expected_data_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_valid=%b",
                         data_out, data_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_valid=%b",
                         expected_data_out, expected_data_valid);
                $display("  Got:      data_out=%h, data_valid=%b",
                         data_out, data_valid);
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
        $dumpvars(0,CLKDIV, DATA_IN, RST, data_out, data_valid);
    end

endmodule
