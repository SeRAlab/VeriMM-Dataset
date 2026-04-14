`timescale 1ns/1ps

module JohnsonCounter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [2:0] counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JohnsonCounter dut (
        .clk(clk),
        .rst_n(rst_n),
        .counter_out(counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking state after 1 clock cycle", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking state after 2 clock cycles", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking state after 3 clock cycles", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking state after 4 clock cycles", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking state after 5 clock cycles", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Checking wrap-around after 6 clock cycles", test_num);
            reset_dut();
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Checking stability after 13 clock cycles", test_num);
            reset_dut();
            repeat(13) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JohnsonCounter Testbench");
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
        input [2:0] expected_counter_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h",
                         counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h",
                         expected_counter_out);
                $display("  Got:      counter_out=%h",
                         counter_out);
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
        $dumpvars(0,clk, rst_n, counter_out);
    end

endmodule
