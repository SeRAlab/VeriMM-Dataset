`timescale 1ns/1ps

module encoder_8to3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_8to3 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: No input bits set", test_num);
        in = 8'b0000_0000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Bit 0 set", test_num);
        in = 8'b0000_0001;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Bit 1 set", test_num);
        in = 8'b0000_0010;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Bit 2 set", test_num);
        in = 8'b0000_0100;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Bit 3 set", test_num);
        in = 8'b0000_1000;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %03d: Bit 4 set", test_num);
        in = 8'b0001_0000;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %03d: Bit 5 set", test_num);
        in = 8'b0010_0000;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %03d: Bit 6 set", test_num);
        in = 8'b0100_0000;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case %03d: Bit 7 set", test_num);
        in = 8'b1000_0000;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case %03d: Priority test - multiple bits (Bit 7 highest)", test_num);
        in = 8'b1111_1111;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case %03d: Priority test - bits 0, 1, 2 (Bit 2 highest)", test_num);
        in = 8'b0000_0111;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test Case %03d: Priority test - bits 4 and 6 (Bit 6 highest)", test_num);
        in = 8'b0101_0000;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test Case %03d: Priority test - bits 3 and 5 (Bit 5 highest)", test_num);
        in = 8'b0010_1000;
        #1;

        check_outputs(3'b101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_8to3 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
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
        input [2:0] expected_out;
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
