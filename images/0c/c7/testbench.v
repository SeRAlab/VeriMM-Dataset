`timescale 1ns/1ps

module eight_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire COUT;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eight_bit_adder dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 8'h00; B = 8'h00;
        $display("Test %0d: 0x00 + 0x00", test_num);
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 8'h05; B = 8'h0A;
        $display("Test %0d: 0x05 + 0x0A", test_num);
        #1;

        check_outputs(1'b0, 8'h0F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 8'hAA; B = 8'h55;
        $display("Test %0d: 0xAA + 0x55", test_num);
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 8'hFE; B = 8'h01;
        $display("Test %0d: 0xFE + 0x01", test_num);
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 8'hFF; B = 8'h01;
        $display("Test %0d: 0xFF + 0x01 (Carry expected)", test_num);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 8'h80; B = 8'h80;
        $display("Test %0d: 0x80 + 0x80 (Carry expected)", test_num);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 8'hC0; B = 8'h50;
        $display("Test %0d: 0xC0 + 0x50", test_num);
        #1;

        check_outputs(1'b1, 8'h10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 8'hFF; B = 8'hFF;
        $display("Test %0d: 0xFF + 0xFF", test_num);
        #1;

        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 8'h33; B = 8'hCC;
        $display("Test %0d: 0x33 + 0xCC", test_num);
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 8'h0F; B = 8'h01;
        $display("Test %0d: 0x0F + 0x01", test_num);
        #1;

        check_outputs(1'b0, 8'h10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eight_bit_adder Testbench");
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
        input expected_COUT;
        input [7:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
