`timescale 1ns/1ps

module comparator_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire eq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_2bit dut (
        .a(a),
        .b(b),
        .eq(eq)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 2'b00; b = 2'b00;
        $display("Testcase %0d: Testing 0 == 0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 2'b00; b = 2'b01;
        $display("Testcase %0d: Testing 0 == 1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 2'b00; b = 2'b10;
        $display("Testcase %0d: Testing 0 == 2", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 2'b00; b = 2'b11;
        $display("Testcase %0d: Testing 0 == 3", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 2'b01; b = 2'b00;
        $display("Testcase %0d: Testing 1 == 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 2'b01; b = 2'b01;
        $display("Testcase %0d: Testing 1 == 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 2'b01; b = 2'b10;
        $display("Testcase %0d: Testing 1 == 2", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 2'b01; b = 2'b11;
        $display("Testcase %0d: Testing 1 == 3", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 2'b10; b = 2'b00;
        $display("Testcase %0d: Testing 2 == 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 2'b10; b = 2'b01;
        $display("Testcase %0d: Testing 2 == 1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        a = 2'b10; b = 2'b10;
        $display("Testcase %0d: Testing 2 == 2", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        a = 2'b10; b = 2'b11;
        $display("Testcase %0d: Testing 2 == 3", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        a = 2'b11; b = 2'b00;
        $display("Testcase %0d: Testing 3 == 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        a = 2'b11; b = 2'b01;
        $display("Testcase %0d: Testing 3 == 1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        a = 2'b11; b = 2'b10;
        $display("Testcase %0d: Testing 3 == 2", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        a = 2'b11; b = 2'b11;
        $display("Testcase %0d: Testing 3 == 3", test_num);
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
        $display("comparator_2bit Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_eq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq)) begin
                $display("PASS");
                $display("  Outputs: eq=%b",
                         eq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b",
                         expected_eq);
                $display("  Got:      eq=%b",
                         eq);
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
