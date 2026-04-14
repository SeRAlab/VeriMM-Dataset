`timescale 1ns/1ps

module fsm_next_state_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg [1:0] t;
    wire S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_next_state dut (
        .d(d),
        .t(t),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        t = 2'b00; d = 1'b0;
        $display("Testcase %0d: State I (00), d=0 -> Expected S=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        t = 2'b00; d = 1'b1;
        $display("Testcase %0d: State I (00), d=1 -> Expected S=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        t = 2'b01; d = 1'b0;
        $display("Testcase %0d: State J (01), d=0 -> Expected S=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        t = 2'b01; d = 1'b1;
        $display("Testcase %0d: State J (01), d=1 -> Expected S=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        t = 2'b10; d = 1'b0;
        $display("Testcase %0d: State K (10), d=0 -> Expected S=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        t = 2'b10; d = 1'b1;
        $display("Testcase %0d: State K (10), d=1 -> Expected S=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        t = 2'b11; d = 1'b0;
        $display("Testcase %0d: State L (11), d=0 -> Expected S=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        t = 2'b11; d = 1'b1;
        $display("Testcase %0d: State L (11), d=1 -> Expected S=0", test_num);
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
        $display("fsm_next_state Testbench");
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
        input expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%b",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%b",
                         expected_S);
                $display("  Got:      S=%b",
                         S);
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

endmodule
