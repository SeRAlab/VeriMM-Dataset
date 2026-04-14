`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] shift;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .A(A),
        .B(B),
        .shift(shift),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 16'hAAAA;
        B = 16'h5555;
        shift = 4'b0000;
        $display("Testcase %03d: Shift is 0, out should be B", test_num);
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 16'h8001;
        B = 16'h0000;
        shift = 4'b1001;
        $display("Testcase %03d: Logical Shift Right by 1", test_num);
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 16'hFF00;
        B = 16'h0000;
        shift = 4'b1111;
        $display("Testcase %03d: Logical Shift Right by 7", test_num);
        #1;

        check_outputs(16'h01FE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 16'hABCD;
        B = 16'h1234;
        shift = 4'b1000;
        $display("Testcase %03d: Logical Mode, shift amount 0", test_num);
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 16'h8002;
        B = 16'h0000;
        shift = 4'b0001;
        $display("Testcase %03d: Arithmetic Shift Right by 1 (Sign bit 1)", test_num);
        #1;

        check_outputs(16'hC001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 16'h7002;
        B = 16'h0000;
        shift = 4'b0001;
        $display("Testcase %03d: Arithmetic Shift Right by 1 (Sign bit 0)", test_num);
        #1;

        check_outputs(16'h3801);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 16'hF000;
        B = 16'h0000;
        shift = 4'b0100;
        $display("Testcase %03d: Arithmetic Shift Right by 4 (Sign extension)", test_num);
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 16'h8000;
        B = 16'h0000;
        shift = 4'b0111;
        $display("Testcase %03d: Arithmetic Shift Right by 7 (Maximum amount)", test_num);
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 16'hFFFF;
        B = 16'h1234;
        shift = 4'b0000;
        $display("Testcase %03d: Transparency Mode check (shift=0, B=0x1234)", test_num);
        #1;

        check_outputs(16'h1234);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter Testbench");
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
        input [15:0] expected_out;
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
