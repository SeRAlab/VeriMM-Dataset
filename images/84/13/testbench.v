`timescale 1ns/1ps

module load_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg load;
    reg rst_n;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    load_reg dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1'b0;
            load = 1'b0;
            data_in = 32'h0;
            #15;
            rst_n = 1'b1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Loading 32'hA5A5_5A5A", test_num);
            reset_dut();
            data_in = 32'hA5A5_5A5A;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Verify data hold (load=0)", test_num);
            reset_dut();

            data_in = 32'h1234_5678;
            load = 1'b1;
            @(posedge clk);
            #1;

            data_in = 32'hFFFF_FFFF;
            load = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Load all zeros (after non-zero)", test_num);
            reset_dut();

            data_in = 32'hFFFF_FFFF;
            load = 1'b1;
            @(posedge clk);
            #1;

            data_in = 32'h0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Load all ones", test_num);
            reset_dut();
            data_in = 32'hFFFF_FFFF;
            load = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Back-to-back load updates", test_num);
            reset_dut();
            load = 1'b1;
            data_in = 32'hDEADD00D;
            @(posedge clk);
            #1;
            data_in = 32'hBEEFCAFE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hBEEFCAFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Asynchronous reset priority", test_num);
            reset_dut();

            data_in = 32'hABCD_1234;
            load = 1'b1;
            @(posedge clk);
            #1;

            rst_n = 1'b0;
            #2;
            #1;

            check_outputs(32'h0000_0000);

            rst_n = 1'b1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("load_reg Testbench");
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, data_in, load, rst_n, Q);
    end

endmodule
