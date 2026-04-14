`timescale 1ns/1ps

module mem_protect_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] addr;
    reg [1:0] ctrl;
    wire mem_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mem_protect dut (
        .addr(addr),
        .ctrl(ctrl),
        .mem_en(mem_en)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid address within range, Active control", test_num);
            addr = 4'd5;
            ctrl = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid address within range, Inactive control", test_num);
            addr = 4'd5;
            ctrl = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address at lower boundary (0), Active control", test_num);
            addr = 4'd0;
            ctrl = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address at upper boundary (size-1), Active control", test_num);
            addr = 4'd9;
            ctrl = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address just outside boundary (size), Active control", test_num);
            addr = 4'd10;
            ctrl = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address far outside range, Active control", test_num);
            addr = 4'd15;
            ctrl = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address far outside range, Inactive control", test_num);
            addr = 4'd14;
            ctrl = 2'b00;
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
        $display("mem_protect Testbench");
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
        input expected_mem_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_en === (expected_mem_en ^ mem_en ^ expected_mem_en)) begin
                $display("PASS");
                $display("  Outputs: mem_en=%b",
                         mem_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_en=%b",
                         expected_mem_en);
                $display("  Got:      mem_en=%b",
                         mem_en);
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
