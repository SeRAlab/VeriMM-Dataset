`timescale 1ns/1ps

module mux32to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] d;
    reg [4:0] s;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux32to1 dut (
        .d(d),
        .s(s),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Index 0, Input 1", test_num);
        d = 32'h00000001;
        s = 5'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Index 31, Input 1", test_num);
        d = 32'h80000000;
        s = 5'd31;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Index 15, Input 1", test_num);
        d = 32'h00008000;
        s = 5'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Index 7, Input 0 (others high)", test_num);
        d = 32'hFFFFFF7F;
        s = 5'd7;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Index 22, Input 1", test_num);
        d = 32'h00400000;
        s = 5'd22;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Index 31, Input 0", test_num);
        d = 32'h7FFFFFFF;
        s = 5'd31;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

        integer i;
        begin
            $display("\nTestcase 007: Walking 1 Sweep (Indices 0 to 31)");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = test_num + 1;
                d = (32'b1 << i);
                s = i[4:0];
                #1;

                check_outputs(1'b1);
            end
        end
        endtask

    task testcase008;

        integer j;
        begin
            $display("\nTestcase 008: Walking 0 Sweep (Indices 0 to 31)");
            for (j = 0; j < 32; j = j + 1) begin
                test_num = test_num + 1;
                d = ~(32'b1 << j);
                s = j[4:0];
                #1;

                check_outputs(1'b0);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux32to1 Testbench");
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
