`timescale 1ns/1ps

module max_finder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg [4:0] C;
    wire [4:0] max_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_finder dut (
        .A(A),
        .B(B),
        .C(C),
        .max_out(max_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All inputs identical", test_num);
        A = 5'd10; B = 5'd10; C = 5'd10;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: A is maximum", test_num);
        A = 5'd25; B = 5'd10; C = 5'd5;
        #1;

        check_outputs(5'd25);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: B is maximum", test_num);
        A = 5'd4; B = 5'd30; C = 5'd12;
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: C is maximum", test_num);
        A = 5'd0; B = 5'd15; C = 5'd22;
        #1;

        check_outputs(5'd22);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Two inputs equal and maximum (A and B)", test_num);
        A = 5'd18; B = 5'd18; C = 5'd3;
        #1;

        check_outputs(5'd18);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Two inputs equal and maximum (B and C)", test_num);
        A = 5'd7; B = 5'd20; C = 5'd20;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Minimum boundary (All zeros)", test_num);
        A = 5'd0; B = 5'd0; C = 5'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Maximum boundary (All ones)", test_num);
        A = 5'd31; B = 5'd31; C = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Maximum boundary mixed", test_num);
        A = 5'd31; B = 5'd0; C = 5'd16;
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
        $display("max_finder Testbench");
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
        input [4:0] expected_max_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_out === (expected_max_out ^ max_out ^ expected_max_out)) begin
                $display("PASS");
                $display("  Outputs: max_out=%h",
                         max_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_out=%h",
                         expected_max_out);
                $display("  Got:      max_out=%h",
                         max_out);
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
