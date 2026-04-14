`timescale 1ns/1ps

module checksum_checker_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid;
    wire [3:0] checksum_out;
    wire integrity_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_checker dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .checksum_out(checksum_out),
        .integrity_flag(integrity_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h00;
            valid = 1'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros pattern", test_num);
            reset_dut();
            data_in = 8'b00000000;
            valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones pattern", test_num);
            reset_dut();
            data_in = 8'b11111111;
            valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd8, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits pattern (0xAA)", test_num);
            reset_dut();
            data_in = 8'hAA;
            valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd4, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit set", test_num);
            reset_dut();
            data_in = 8'h80;
            valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lower nibble set", test_num);
            reset_dut();
            data_in = 8'h0F;
            valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd4, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex bit pattern (0x77)", test_num);
            reset_dut();
            data_in = 8'h77;
            valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd6, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid signal de-asserted", test_num);
            reset_dut();
            data_in = 8'hFF;
            valid = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High density pattern (0xFE)", test_num);
            reset_dut();
            data_in = 8'hFE;
            valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd7, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_checker Testbench");
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
        input [3:0] expected_checksum_out;
        input expected_integrity_flag;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_integrity_flag === (expected_integrity_flag ^ integrity_flag ^ expected_integrity_flag)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, integrity_flag=%b",
                         checksum_out, integrity_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, integrity_flag=%b",
                         expected_checksum_out, expected_integrity_flag);
                $display("  Got:      checksum_out=%h, integrity_flag=%b",
                         checksum_out, integrity_flag);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_in, rst, valid, checksum_out, integrity_flag);
    end

endmodule
