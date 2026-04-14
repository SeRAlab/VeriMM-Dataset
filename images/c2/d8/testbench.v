`timescale 1ns/1ps

module InnerBlend_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg [4:0] C;
    reg [8:0] Op;
    wire [4:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    InnerBlend dut (
        .A(A),
        .B(B),
        .C(C),
        .Op(Op),
        .O(O)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select A (Op[8]=1)", test_num);
        A = 5'd15; B = 5'd31; C = 5'd10;
        Op = 9'b1_0000_00_00;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sum with all factors = 1", test_num);
        A = 5'd5; B = 5'd10; C = 5'd7;
        Op = 9'b0_0001_01_01;
        #1;

        check_outputs(5'd22);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Only A factor active", test_num);
        A = 5'd4; B = 5'd31; C = 5'd31;
        Op = 9'b0_0011_00_00;
        #1;

        check_outputs(5'd12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Only B factor active", test_num);
        A = 5'd31; B = 5'd6; C = 5'd31;
        Op = 9'b0_0000_10_00;
        #1;

        check_outputs(5'd12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Only C factor active", test_num);
        A = 5'd31; B = 5'd31; C = 5'd8;
        Op = 9'b0_0000_00_11;
        #1;

        check_outputs(5'd24);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed factors, no overflow", test_num);
        A = 5'd2; B = 5'd3; C = 5'd4;
        Op = 9'b0_0101_10_01;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sum with overflow (> 31)", test_num);
        A = 5'd10; B = 5'd10; C = 5'd10;
        Op = 9'b0_0010_01_01;
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero inputs and factors", test_num);
        A = 5'd0; B = 5'd0; C = 5'd0;
        Op = 9'b0_1111_11_11;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max scaling and truncation check", test_num);
        A = 5'd31; B = 5'd0; C = 5'd0;
        Op = 9'b0_1111_00_00;
        #1;

        check_outputs(5'd17);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Op[8]=1 overrides high multipliers", test_num);
        A = 5'd7; B = 5'd31; C = 5'd31;
        Op = 9'b1_1111_11_11;
        #1;

        check_outputs(5'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("InnerBlend Testbench");
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
        input [4:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
