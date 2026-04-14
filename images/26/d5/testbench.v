`timescale 1ns/1ps

module nearest_neighbor_interp_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg [4:0] X;
    wire [4:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interp dut (
        .A(A),
        .B(B),
        .X(X),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: X equals A", test_num);
        A = 5'd10; B = 5'd20; X = 5'd10;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: X equals B", test_num);
        A = 5'd10; B = 5'd20; X = 5'd20;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: X closer to A (inside range)", test_num);
        A = 5'd10; B = 5'd20; X = 5'd13;

        #1;


        check_outputs(5'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: X closer to B (inside range)", test_num);
        A = 5'd10; B = 5'd20; X = 5'd17;

        #1;


        check_outputs(5'd20);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: X at midpoint (Equidistant), prefer A", test_num);
        A = 5'd10; B = 5'd20; X = 5'd15;

        #1;


        check_outputs(5'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: X at midpoint (A > B), prefer A", test_num);
        A = 5'd25; B = 5'd15; X = 5'd20;

        #1;


        check_outputs(5'd25);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: X outside range (smaller than both)", test_num);
        A = 5'd10; B = 5'd20; X = 5'd2;

        #1;


        check_outputs(5'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: X outside range (larger than both)", test_num);
        A = 5'd10; B = 5'd20; X = 5'd30;

        #1;


        check_outputs(5'd20);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: A equals B", test_num);
        A = 5'd15; B = 5'd15; X = 5'd0;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Extreme bounds check", test_num);
        A = 5'd0; B = 5'd31; X = 5'd16;

        #1;


        check_outputs(5'd31);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nearest_neighbor_interp Testbench");
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
        input [4:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
