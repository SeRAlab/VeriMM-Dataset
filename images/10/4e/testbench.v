`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] control;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 32'h0000_000A;
        B = 32'h0000_0014;
        control = 4'd0;
        $display("Test %0d: ADD operation (10 + 20)", test_num);
        #1;

        check_outputs(32'h0000_001E);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'h0000_0064;
        B = 32'h0000_0028;
        control = 4'd1;
        $display("Test %0d: SUB operation (100 - 40)", test_num);
        #1;

        check_outputs(32'h0000_003C);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'hFFFF_0000;
        B = 32'hAAAA_AAAA;
        control = 4'd2;
        $display("Test %0d: AND operation", test_num);
        #1;

        check_outputs(32'hAAAA_0000);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        A = 32'hF0F0_F0F0;
        B = 32'h0F0F_0F0F;
        control = 4'd3;
        $display("Test %0d: OR operation", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'h1234_5678;
        B = 32'h1234_5678;
        control = 4'd4;
        $display("Test %0d: XOR operation (A ^ A)", test_num);
        #1;

        check_outputs(32'h0000_0000);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        A = 32'h5555_5555;
        B = 32'h0000_0000;
        control = 4'd5;
        $display("Test %0d: NOT operation (~A)", test_num);
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_FFFF;
        control = 4'd6;
        $display("Test %0d: NAND operation", test_num);
        #1;

        check_outputs(32'hFFFF_0000);
    end
    endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'h0000_0000;
        B = 32'h0000_0000;
        control = 4'd7;
        $display("Test %0d: NOR operation (0 NOR 0)", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
    endtask

    task testcase009;

    begin
        test_num = 9;
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        control = 4'd8;
        $display("Test %0d: XNOR operation", test_num);
        #1;

        check_outputs(32'h0000_0000);
    end
    endtask

    task testcase010;

    begin
        test_num = 10;
        A = 32'h0000_0001;
        B = 32'h0000_0004;
        control = 4'd9;
        $display("Test %0d: SHIFT LEFT logical (1 << 4)", test_num);
        #1;

        check_outputs(32'h0000_0010);
    end
    endtask

    task testcase011;

    begin
        test_num = 11;
        A = 32'h8000_0000;
        B = 32'h0000_0002;
        control = 4'd10;
        $display("Test %0d: SHIFT RIGHT logical (0x80.. >> 2)", test_num);
        #1;

        check_outputs(32'h2000_0000);
    end
    endtask

    task testcase012;

    begin
        test_num = 12;
        A = 32'h0000_000F;
        B = 32'h0000_0001;
        control = 4'd11;
        $display("Test %0d: SHIFT LEFT arithmetic", test_num);
        #1;

        check_outputs(32'h0000_001E);
    end
    endtask

    task testcase013;

    begin
        test_num = 13;
        A = 32'h8000_0000;
        B = 32'h0000_0001;
        control = 4'd12;
        $display("Test %0d: SHIFT RIGHT arithmetic (sign extension)", test_num);
        #1;

        check_outputs(32'hC000_0000);
    end
    endtask

    task testcase014;

    begin
        test_num = 14;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        control = 4'd0;
        $display("Test %0d: ADD overflow check (Max + 1)", test_num);
        #1;

        check_outputs(32'h0000_0000);
    end
    endtask

    task testcase015;

    begin
        test_num = 15;
        A = 32'h0000_0000;
        B = 32'h0000_0001;
        control = 4'd1;
        $display("Test %0d: SUB underflow check (0 - 1)", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
    endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
