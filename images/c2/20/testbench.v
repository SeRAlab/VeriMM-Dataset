`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    reg [31:0] D;
    reg [1:0] S;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input A (S=00)", test_num);
        A = 32'hAAAAAAAA;
        B = 32'hBBBBBBBB;
        C = 32'hCCCCCCCC;
        D = 32'hDDDDDDDD;
        S = 2'b00;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input B (S=01)", test_num);
        A = 32'hAAAAAAAA;
        B = 32'hBBBBBBBB;
        C = 32'hCCCCCCCC;
        D = 32'hDDDDDDDD;
        S = 2'b01;
        #1;

        check_outputs(32'hBBBBBBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input C (S=10)", test_num);
        A = 32'hAAAAAAAA;
        B = 32'hBBBBBBBB;
        C = 32'hCCCCCCCC;
        D = 32'hDDDDDDDD;
        S = 2'b10;
        #1;

        check_outputs(32'hCCCCCCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input D (S=11)", test_num);
        A = 32'hAAAAAAAA;
        B = 32'hBBBBBBBB;
        C = 32'hCCCCCCCC;
        D = 32'hDDDDDDDD;
        S = 2'b11;
        #1;

        check_outputs(32'hDDDDDDDD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs zero, select B", test_num);
        A = 32'h0;
        B = 32'h0;
        C = 32'h0;
        D = 32'h0;
        S = 2'b01;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs FFFF_FFFF, select D", test_num);
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        C = 32'hFFFFFFFF;
        D = 32'hFFFFFFFF;
        S = 2'b11;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bit pattern, select A", test_num);
        A = 32'h55555555;
        B = 32'hAAAAAAAA;
        C = 32'h00000000;
        D = 32'hFFFFFFFF;
        S = 2'b00;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking bit test, select C", test_num);
        A = 32'h00000001;
        B = 32'h00000002;
        C = 32'h00000004;
        D = 32'h00000008;
        S = 2'b10;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random pattern test, select B", test_num);
        A = 32'h12345678;
        B = 32'h9ABCDEF0;
        C = 32'hF0E1D2C3;
        D = 32'hB4A59687;
        S = 2'b01;
        #1;

        check_outputs(32'h9ABCDEF0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Change select dynamically, select D", test_num);
        A = 32'h11111111;
        B = 32'h22222222;
        C = 32'h33333333;
        D = 32'h44444444;
        S = 2'b00; #5;
        S = 2'b11;
        #1;

        check_outputs(32'h44444444);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
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
        input [31:0] expected_Y;
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
