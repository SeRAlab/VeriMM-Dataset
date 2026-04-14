`timescale 1ns/1ps

module register12_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] D;
    reg clk;
    reg en;
    reg set;
    wire [11:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register12 dut (
        .D(D),
        .clk(clk),
        .en(en),
        .set(set),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            set = 1;
            en = 0;
            D = 0;
            #15;
            set = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Asynchronous Set", test_num);
            reset_dut();


            set = 1;
            #5;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load data 12'hA5A with en=1", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            D = 12'hA5A;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify data hold when en=0", test_num);
            reset_dut();

            @(posedge clk);
            en = 1;
            D = 12'h123;
            @(posedge clk);

            #2;
            en = 0;
            D = 12'hFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify async set priority during load", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            D = 12'hABC;
            #2;
            set = 1;
            #5;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 12'h000", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            D = 12'h000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive writes", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            D = 12'hAAA;
            @(posedge clk);
            D = 12'h555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Change D without clock edge", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            D = 12'h777;
            @(posedge clk);
            #2;

            D = 12'h888;
            #3;
            #1;

            check_outputs(12'h777);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register12 Testbench");
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
        input [11:0] expected_Q;
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
        $dumpvars(0,D, clk, en, set, Q);
    end

endmodule
