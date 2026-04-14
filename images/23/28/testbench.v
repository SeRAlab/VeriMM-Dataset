`timescale 1ns/1ps

module serializer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] parallel_in;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer_32bit dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            parallel_in = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All ones - Check bit 1 (MSB)");
            reset_dut();
            parallel_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All zeros - Check bit 1 (MSB)");
            reset_dut();
            parallel_in = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: MSB set (0x80000000) - Check bit 1");
            reset_dut();
            parallel_in = 32'h80000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: MSB set (0x80000000) - Check bit 32");
            reset_dut();
            parallel_in = 32'h80000000;
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: LSB set (0x00000001) - Check bit 1");
            reset_dut();
            parallel_in = 32'h00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: LSB set (0x00000001) - Check bit 32");
            reset_dut();
            parallel_in = 32'h00000001;
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: 0xAAAAAAAA - Check bit 1");
            reset_dut();
            parallel_in = 32'hAAAAAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: 0xAAAAAAAA - Check bit 2");
            reset_dut();
            parallel_in = 32'hAAAAAAAA;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: 0x55555555 - Check bit 1");
            reset_dut();
            parallel_in = 32'h55555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: 0x55555555 - Check bit 2");
            reset_dut();
            parallel_in = 32'h55555555;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: 0xF0F0F0F0 - Check bit 5");
            reset_dut();
            parallel_in = 32'hF0F0F0F0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);



        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: 0xFFFF0000 - Check bit 16");
            reset_dut();
            parallel_in = 32'hFFFF0000;
            repeat(16) @(posedge clk);
            #1;
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
        $display("serializer_32bit Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, parallel_in, serial_out);
    end

endmodule
