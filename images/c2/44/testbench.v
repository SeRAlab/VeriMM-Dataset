`timescale 1ns/1ps

module parity_checker_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg en;
    reg rst;
    wire even_parity;
    wire odd_parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parity_checker dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .rst(rst),
        .even_parity(even_parity),
        .odd_parity(odd_parity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            en = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            rst = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset logic check (both outputs should be 0)");
            rst = 0;
            en = 1;
            data_in = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
            rst = 1;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Input 4'b0000, En=1 (0 ones)");
            reset_dut();
            en = 1;
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Input 4'b0001, En=1 (1 one)");
            reset_dut();
            en = 1;
            data_in = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Input 4'b0011, En=1 (2 ones)");
            reset_dut();
            en = 1;
            data_in = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Input 4'b0111, En=1 (3 ones)");
            reset_dut();
            en = 1;
            data_in = 4'b0111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Input 4'b1111, En=1 (4 ones)");
            reset_dut();
            en = 1;
            data_in = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Hold logic check (Enable 1 -> 0)");
            reset_dut();


            en = 1;
            data_in = 4'b1000;
            @(posedge clk);
            #1;


            en = 0;
            data_in = 4'b1111;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Resume calculation after Hold");
            reset_dut();


            en = 0;
            data_in = 4'b1111;
            @(posedge clk);
            #1;


            en = 1;
            data_in = 4'b1010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parity_checker Testbench");
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
        input expected_even_parity;
        input expected_odd_parity;
        begin
            if (expected_even_parity === (expected_even_parity ^ even_parity ^ expected_even_parity) &&
                expected_odd_parity === (expected_odd_parity ^ odd_parity ^ expected_odd_parity)) begin
                $display("PASS");
                $display("  Outputs: even_parity=%b, odd_parity=%b",
                         even_parity, odd_parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: even_parity=%b, odd_parity=%b",
                         expected_even_parity, expected_odd_parity);
                $display("  Got:      even_parity=%b, odd_parity=%b",
                         even_parity, odd_parity);
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
        $dumpvars(0,clk, data_in, en, rst, even_parity, odd_parity);
    end

endmodule
