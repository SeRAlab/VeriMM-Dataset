`timescale 1ns/1ps

module ALU_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] sel;
    wire C;
    wire [7:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_8bit dut (
        .A(A),
        .B(B),
        .sel(sel),
        .C(C),
        .R(R)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: AND operation (sel=000)", test_num);
        A = 8'hAA; B = 8'hCC; sel = 3'b000;
        #1;

        check_outputs(1'b0, 8'h88);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: OR operation (sel=001)", test_num);
        A = 8'hAA; B = 8'hCC; sel = 3'b001;
        #1;

        check_outputs(1'b0, 8'hEE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR operation (sel=010)", test_num);
        A = 8'hAA; B = 8'hCC; sel = 3'b010;
        #1;

        check_outputs(1'b0, 8'h66);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD operation - No Carry (sel=011)", test_num);
        A = 8'h12; B = 8'h34; sel = 3'b011;
        #1;

        check_outputs(1'b0, 8'h46);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD operation - With Carry (sel=011)", test_num);
        A = 8'hFF; B = 8'h01; sel = 3'b011;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUB operation - No Borrow (sel=100)", test_num);
        A = 8'h50; B = 8'h20; sel = 3'b100;
        #1;

        check_outputs(1'b0, 8'h30);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUB operation - With Borrow (sel=100)", test_num);
        A = 8'h10; B = 8'h20; sel = 3'b100;
        #1;

        check_outputs(1'b1, 8'hF0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NAND operation (sel=101)", test_num);
        A = 8'hAA; B = 8'hCC; sel = 3'b101;
        #1;

        check_outputs(1'b0, 8'h77);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NOR operation (sel=110)", test_num);
        A = 8'h0F; B = 8'hF0; sel = 3'b110;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XNOR operation (sel=111)", test_num);
        A = 8'hAA; B = 8'hCC; sel = 3'b111;
        #1;

        check_outputs(1'b0, 8'h99);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_8bit Testbench");
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
        input expected_C;
        input [7:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: C=%b, R=%h",
                         C, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, R=%h",
                         expected_C, expected_R);
                $display("  Got:      C=%b, R=%h",
                         C, R);
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
