`timescale 1ns/1ps

module mux_16to1_tb;

    // Testbench signals (combinational circuit)
    reg D0;
    reg D1;
    reg D10;
    reg D11;
    reg D12;
    reg D13;
    reg D14;
    reg D15;
    reg D2;
    reg D3;
    reg D4;
    reg D5;
    reg D6;
    reg D7;
    reg D8;
    reg D9;
    reg [3:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_16to1 dut (
        .D0(D0),
        .D1(D1),
        .D10(D10),
        .D11(D11),
        .D12(D12),
        .D13(D13),
        .D14(D14),
        .D15(D15),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5),
        .D6(D6),
        .D7(D7),
        .D8(D8),
        .D9(D9),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select D0, S=0", test_num);
        S = 4'd0;
        D0=1; D1=0; D2=0; D3=0; D4=0; D5=0; D6=0; D7=0;
        D8=0; D9=0; D10=0; D11=0; D12=0; D13=0; D14=0; D15=0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select D1, S=1", test_num);
        S = 4'd1;
        D0=0; D1=1; D2=0; D3=0; D4=0; D5=0; D6=0; D7=0;
        D8=0; D9=0; D10=0; D11=0; D12=0; D13=0; D14=0; D15=0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select D4, S=4", test_num);
        S = 4'd4;
        D0=0; D1=0; D2=0; D3=0; D4=1; D5=0; D6=0; D7=0;
        D8=0; D9=0; D10=0; D11=0; D12=0; D13=0; D14=0; D15=0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select D7, S=7", test_num);
        S = 4'd7;
        D0=0; D1=0; D2=0; D3=0; D4=0; D5=0; D6=0; D7=1;
        D8=0; D9=0; D10=0; D11=0; D12=0; D13=0; D14=0; D15=0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select D8, S=8", test_num);
        S = 4'd8;
        D0=0; D1=0; D2=0; D3=0; D4=0; D5=0; D6=0; D7=0;
        D8=1; D9=0; D10=0; D11=0; D12=0; D13=0; D14=0; D15=0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select D11, S=11", test_num);
        S = 4'd11;
        D0=0; D1=0; D2=0; D3=0; D4=0; D5=0; D6=0; D7=0;
        D8=0; D9=0; D10=0; D11=1; D12=0; D13=0; D14=0; D15=0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select D15, S=15", test_num);
        S = 4'd15;
        D0=0; D1=0; D2=0; D3=0; D4=0; D5=0; D6=0; D7=0;
        D8=0; D9=0; D10=0; D11=0; D12=0; D13=0; D14=0; D15=1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logic Transparency, S=2, D2=0", test_num);
        S = 4'd2;
        D0=1; D1=1; D2=0; D3=1; D4=1; D5=1; D6=1; D7=1;
        D8=1; D9=1; D10=1; D11=1; D12=1; D13=1; D14=1; D15=1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logic Transparency, S=13, D13=0", test_num);
        S = 4'd13;
        D0=1; D1=1; D2=1; D3=1; D4=1; D5=1; D6=1; D7=1;
        D8=1; D9=1; D10=1; D11=1; D12=1; D13=0; D14=1; D15=1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Switch, S=10, D10=1", test_num);
        D0=0; D1=0; D2=0; D3=0; D4=0; D5=0; D6=0; D7=0;
        D8=0; D9=0; D10=1; D11=0; D12=0; D13=0; D14=0; D15=0;
        S = 4'd10;
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
        $display("mux_16to1 Testbench");
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
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
