`timescale 1ns/1ps

module ALU_Data_Forwarding_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] forwarded_data;
    reg [1:0] select;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_Data_Forwarding dut (
        .A(A),
        .B(B),
        .forwarded_data(forwarded_data),
        .select(select),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd5;
        B = 4'd3;
        forwarded_data = 4'd0;
        select = 2'b00;
        $display("Test %0d: Addition - %d + %d", test_num, A, B);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd10;
        B = 4'd4;
        forwarded_data = 4'd0;
        select = 2'b01;
        $display("Test %0d: Subtraction - %d - %d", test_num, A, B);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b1100;
        B = 4'b1010;
        forwarded_data = 4'd0;
        select = 2'b10;
        $display("Test %0d: Bitwise AND - %b & %b", test_num, A, B);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b1100;
        B = 4'b0011;
        forwarded_data = 4'd0;
        select = 2'b11;
        $display("Test %0d: Bitwise OR - %b | %b", test_num, A, B);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd0;
        B = 4'd4;
        forwarded_data = 4'd7;
        select = 2'b00;
        $display("Test %0d: Forwarded Addition - FW(%d) + B(%d)", test_num, forwarded_data, B);

        #1;


        check_outputs(4'd11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'hF;
        B = 4'd5;
        forwarded_data = 4'd5;
        select = 2'b01;
        $display("Test %0d: Forwarded Subtraction - FW(%d) - B(%d)", test_num, forwarded_data, B);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'hF;
        B = 4'h1;
        forwarded_data = 4'h0;
        select = 2'b00;
        $display("Test %0d: Wrap-around Addition - %h + %h", test_num, A, B);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b0000;
        B = 4'b1111;
        forwarded_data = 4'b1010;
        select = 2'b10;
        $display("Test %0d: Forwarded AND - FW(%b) & B(%b)", test_num, forwarded_data, B);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_Data_Forwarding Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_result;
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
