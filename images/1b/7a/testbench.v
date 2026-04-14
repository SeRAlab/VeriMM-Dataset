`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg BL;
    reg D;
    reg WL;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .BL(BL),
        .D(D),
        .WL(WL),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        BL = 0;
        forever #5 BL = ~BL;
    end

        task reset_dut;

        begin
            WL = 1;
            D = 0;
            @(posedge BL);
            WL = 0;
            D = 0;
            @(posedge BL);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 1 and Read 1", test_num);
            reset_dut();

            WL = 1; D = 1;
            @(posedge BL);

            WL = 0; D = 0;
            @(posedge BL);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 0 and Read 0", test_num);
            reset_dut();

            WL = 1; D = 1;
            @(posedge BL);

            WL = 1; D = 0;
            @(posedge BL);

            WL = 0;
            @(posedge BL);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data retention over multiple cycles", test_num);
            reset_dut();

            WL = 1; D = 1;
            @(posedge BL);

            WL = 0; D = 0;
            repeat(4) @(posedge BL);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write inhibit when WL=0", test_num);
            reset_dut();

            WL = 1; D = 1;
            @(posedge BL);

            WL = 0; D = 0;
            @(posedge BL);

            @(posedge BL);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Retention while BL is low", test_num);
            reset_dut();

            WL = 1; D = 1;
            @(posedge BL);

            WL = 0; D = 0;
            @(negedge BL);
            #2;

            @(posedge BL);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write sensitivity to D when WL is High", test_num);
            reset_dut();
            WL = 1; D = 0;
            #2;
            D = 1;
            @(posedge BL);
            WL = 0;
            @(posedge BL);
            #1;

            check_outputs(1'b1);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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
        $dumpvars(0,BL, D, WL, Q);
    end

endmodule
