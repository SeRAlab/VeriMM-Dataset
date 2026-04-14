`timescale 1ns/1ps

module PISO_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [4:0] D;
    reg LOAD;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO dut (
        .CLK(CLK),
        .D(D),
        .LOAD(LOAD),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 0;
            D = 5'b0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 5'b10101 and check bit 0", test_num);
            reset_dut();
            D = 5'b10101;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 5'b10101 and check bit 1 after 1 shift", test_num);
            reset_dut();
            D = 5'b10101;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 5'b10101 and check bit 2 after 2 shifts", test_num);
            reset_dut();
            D = 5'b10101;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 5'b10101 and check bit 3 after 3 shifts", test_num);
            reset_dut();
            D = 5'b10101;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 5'b10101 and check bit 4 after 4 shifts", test_num);
            reset_dut();
            D = 5'b10101;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load all zeros", test_num);
            reset_dut();
            D = 5'b00000;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load all ones", test_num);
            reset_dut();
            D = 5'b11111;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Test LOAD priority (re-loading mid-shift)", test_num);
            reset_dut();

            D = 5'b11111;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            @(posedge CLK);
            #1;

            D = 5'b00000;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PISO Testbench");
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
        $dumpvars(0,CLK, D, LOAD, Q);
    end

endmodule
