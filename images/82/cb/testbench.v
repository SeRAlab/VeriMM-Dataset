`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg invert;
    reg [1:0] select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .invert(invert),
        .select(select),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            select = 2'b00;
            invert = 1'b0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Select 0, Invert 0, Enable 1", test_num);
            select = 2'b00;
            invert = 1'b0;
            @(posedge enable);
            #2;
            #1;

            check_outputs(8'hE1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Select 1, Invert 0, Enable 1", test_num);
            select = 2'b01;
            invert = 1'b0;
            @(posedge enable);
            #2;
            #1;

            check_outputs(8'hD2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Select 2, Invert 0, Enable 1", test_num);
            select = 2'b10;
            invert = 1'b0;
            @(posedge enable);
            #2;
            #1;

            check_outputs(8'hB4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Select 3, Invert 0, Enable 1", test_num);
            select = 2'b11;
            invert = 1'b0;
            @(posedge enable);
            #2;
            #1;

            check_outputs(8'h78);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Select 0, Invert 1, Enable 1", test_num);
            select = 2'b00;
            invert = 1'b1;
            @(posedge enable);
            #2;
            #1;

            check_outputs(8'h1E);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Select 1, Invert 1, Enable 1", test_num);
            select = 2'b01;
            invert = 1'b1;
            @(posedge enable);
            #2;
            #1;

            check_outputs(8'h2D);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Select 2, Invert 1, Enable 1", test_num);
            select = 2'b10;
            invert = 1'b1;
            @(posedge enable);
            #2;
            #1;

            check_outputs(8'h4B);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Select 3, Invert 1, Enable 1", test_num);
            select = 2'b11;
            invert = 1'b1;
            @(posedge enable);
            #2;
            #1;

            check_outputs(8'h87);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Enable 0 (Disabled), Invert 0", test_num);
            invert = 1'b0;
            @(negedge enable);
            #2;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Enable 0 (Disabled), Invert 1", test_num);
            invert = 1'b1;
            @(negedge enable);
            #2;
            #1;

            check_outputs(8'h0F);
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
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,enable, invert, select, out);
    end

endmodule
