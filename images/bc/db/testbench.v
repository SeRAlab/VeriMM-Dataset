`timescale 1ns/1ps

module register10_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] D;
    reg clk;
    reg en;
    reg rst;
    wire [9:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register10 dut (
        .D(D),
        .clk(clk),
        .en(en),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            D = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Data (en=1)", test_num);
            reset_dut();
            D = 10'h3FF;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Hold (en=0)", test_num);
            reset_dut();


            D = 10'h155;
            en = 1;
            @(posedge clk);
            #1;


            en = 0;
            D = 10'h2AA;
            @(posedge clk);
            #1;


            #1;



            check_outputs(10'h155);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority over Enable", test_num);
            reset_dut();


            D = 10'h0AA;
            en = 1;
            @(posedge clk);
            #1;


            D = 10'h3FF;
            en = 1;
            rst = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Sequential Loads", test_num);
            reset_dut();

            en = 1;
            D = 10'h123;
            @(posedge clk);
            D = 10'h321;
            @(posedge clk);
            D = 10'h0F0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'h0F0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset while Enable is Low", test_num);
            reset_dut();


            D = 10'h3AA;
            en = 1;
            @(posedge clk);
            #1;


            rst = 1;
            en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register10 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [9:0] expected_Q;
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
        $dumpvars(0,D, clk, en, rst, Q);
    end

endmodule
