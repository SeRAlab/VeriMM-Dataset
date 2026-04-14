`timescale 1ns/1ps

module simple_fsm_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg e;
    reg [2:0] y;
    wire Y;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_fsm dut (
        .clk(clk),
        .e(e),
        .y(y),
        .Y(Y),
        .z(z)
    );
    task pulse_clk;

        begin
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S0 (000), e=0", test_num);
        y = 3'b000; e = 0;
        pulse_clk();
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S0 (000), e=1", test_num);
        y = 3'b000; e = 1;
        pulse_clk();
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S1 (001), e=0", test_num);
        y = 3'b001; e = 0;
        pulse_clk();
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S1 (001), e=1", test_num);
        y = 3'b001; e = 1;
        pulse_clk();
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S2 (010), e=0", test_num);
        y = 3'b010; e = 0;
        pulse_clk();
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S2 (010), e=1", test_num);
        y = 3'b010; e = 1;
        pulse_clk();
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S3 (011), e=0", test_num);
        y = 3'b011; e = 0;
        pulse_clk();
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S3 (011), e=1", test_num);
        y = 3'b011; e = 1;
        pulse_clk();
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S4 (100), e=0", test_num);
        y = 3'b100; e = 0;
        pulse_clk();
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State S4 (100), e=1", test_num);
        y = 3'b100; e = 1;
        pulse_clk();
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
        $display("simple_fsm Testbench");
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
        input expected_Y;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: Y=%b, z=%b",
                         Y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b, z=%b",
                         expected_Y, expected_z);
                $display("  Got:      Y=%b, z=%b",
                         Y, z);
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
