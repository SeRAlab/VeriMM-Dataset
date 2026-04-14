`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg WL;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .WL(WL),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        WL = 0;
        forever #5 WL = ~WL;
    end

        task reset_dut;

        begin
            D = 4'b0000;

            @(posedge WL);
            @(negedge WL);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write 4'hA", test_num);
            reset_dut();
            @(posedge WL);
            D = 4'hA;
            @(negedge WL);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write 4'h5", test_num);
            reset_dut();
            @(posedge WL);
            D = 4'h5;
            @(negedge WL);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write 4'hF", test_num);
            reset_dut();
            @(posedge WL);
            D = 4'hF;
            @(negedge WL);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write 4'h0", test_num);
            reset_dut();
            @(posedge WL);
            D = 4'h0;
            @(negedge WL);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Retention/Isolation Test", test_num);
            reset_dut();
            @(posedge WL);
            D = 4'hC;
            @(negedge WL);
            #2;
            D = 4'h3;
            #2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Successive Write Cycles", test_num);
            reset_dut();
            @(posedge WL); D = 4'h1;
            @(negedge WL);
            @(posedge WL); D = 4'hE;
            @(negedge WL);
            #1;
            #1;

            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [3:0] expected_Q;
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
        $dumpvars(0,D, WL, Q);
    end

endmodule
