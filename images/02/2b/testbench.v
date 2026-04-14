`timescale 1ns/1ps

module dvfs_control_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] LOAD;
    reg [2:0] TEMP;
    wire [1:0] MODE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_control dut (
        .LOAD(LOAD),
        .TEMP(TEMP),
        .MODE(MODE)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: LOW Mode (TEMP=0, LOAD=0)", test_num);
        TEMP = 3'd0;
        LOAD = 3'd0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: LOW Mode (TEMP=2, LOAD=2)", test_num);
        TEMP = 3'd2;
        LOAD = 3'd2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: MEDIUM Mode (TEMP=3, LOAD=0)", test_num);
        TEMP = 3'd3;
        LOAD = 3'd0;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: MEDIUM Mode (TEMP=0, LOAD=3)", test_num);
        TEMP = 3'd0;
        LOAD = 3'd3;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: MEDIUM Mode (TEMP=5, LOAD=5)", test_num);
        TEMP = 3'd5;
        LOAD = 3'd5;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: HIGH Mode (TEMP=6, LOAD=0)", test_num);
        TEMP = 3'd6;
        LOAD = 3'd0;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: HIGH Mode (TEMP=0, LOAD=6)", test_num);
        TEMP = 3'd0;
        LOAD = 3'd6;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: HIGH Mode (TEMP=7, LOAD=7)", test_num);
        TEMP = 3'd7;
        LOAD = 3'd7;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Priority Check (TEMP=6, LOAD=3) -> HIGH", test_num);
        TEMP = 3'd6;
        LOAD = 3'd3;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Priority Check (TEMP=3, LOAD=1) -> MEDIUM", test_num);
        TEMP = 3'd3;
        LOAD = 3'd1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_control Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_MODE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MODE === (expected_MODE ^ MODE ^ expected_MODE)) begin
                $display("PASS");
                $display("  Outputs: MODE=%h",
                         MODE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MODE=%h",
                         expected_MODE);
                $display("  Got:      MODE=%h",
                         MODE);
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
