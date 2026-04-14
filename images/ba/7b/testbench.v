`timescale 1ns/1ps

module verified_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst_n;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    verified_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;

            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Shift single '1' bit to LSB", test_num);
            reset_dut();


            data_in = 1; @(posedge clk);

            data_in = 0; repeat(7) @(posedge clk);

            #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Fill register with all 1s", test_num);
            reset_dut();

            data_in = 1;
            repeat(8) @(posedge clk);

            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating pattern 10101010 (0xAA)", test_num);
            reset_dut();



            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Specific pattern 10110010 (0xB2)", test_num);
            reset_dut();



            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("verified_shift_register Testbench");
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst_n, data_out);
    end

endmodule
