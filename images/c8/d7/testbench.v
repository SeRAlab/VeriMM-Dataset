`timescale 1ns/1ps

module MUX4_1_SL_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] S0;
    reg [3:0] S1;
    reg [3:0] S2;
    reg [3:0] S3;
    reg [1:0] Sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MUX4_1_SL dut (
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .Sel(Sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        S0 = 4'hA; S1 = 4'h0; S2 = 4'h0; S3 = 4'h0;
        Sel = 2'b00;
        $display("Test Case %0d: Select S0 (Sel=00)", test_num);
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        S0 = 4'h0; S1 = 4'hB; S2 = 4'h0; S3 = 4'h0;
        Sel = 2'b01;
        $display("Test Case %0d: Select S1 (Sel=01)", test_num);
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        S0 = 4'h0; S1 = 4'h0; S2 = 4'hC; S3 = 4'h0;
        Sel = 2'b10;
        $display("Test Case %0d: Select S2 (Sel=10)", test_num);
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        S0 = 4'h0; S1 = 4'h0; S2 = 4'h0; S3 = 4'hD;
        Sel = 2'b11;
        $display("Test Case %0d: Select S3 (Sel=11)", test_num);
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        S0 = 4'h1; S1 = 4'h2; S2 = 4'h4; S3 = 4'h8;
        Sel = 2'b00;
        $display("Test Case %0d: Verify S0 with multiple active inputs", test_num);
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        S0 = 4'h1; S1 = 4'h2; S2 = 4'h4; S3 = 4'h8;
        Sel = 2'b01;
        $display("Test Case %0d: Verify S1 with multiple active inputs", test_num);
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        S0 = 4'h1; S1 = 4'h2; S2 = 4'h4; S3 = 4'h8;
        Sel = 2'b10;
        $display("Test Case %0d: Verify S2 with multiple active inputs", test_num);
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        S0 = 4'h1; S1 = 4'h2; S2 = 4'h4; S3 = 4'h8;
        Sel = 2'b11;
        $display("Test Case %0d: Verify S3 with multiple active inputs", test_num);
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        S0 = 4'hF; S1 = 4'hF; S2 = 4'hF; S3 = 4'hF;
        Sel = 2'b10;
        $display("Test Case %0d: All inputs High", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        S0 = 4'h0; S1 = 4'h0; S2 = 4'h0; S3 = 4'h0;
        Sel = 2'b01;
        $display("Test Case %0d: All inputs Low", test_num);
        #1;

        check_outputs(4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MUX4_1_SL Testbench");
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
