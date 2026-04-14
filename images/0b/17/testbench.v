`timescale 1ns/1ps

module nat_device_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] external_addr;
    reg [7:0] internal_addr;
    reg reset;
    reg send_external;
    reg send_internal;
    wire [7:0] translated_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_device dut (
        .clk(clk),
        .external_addr(external_addr),
        .internal_addr(internal_addr),
        .reset(reset),
        .send_external(send_external),
        .send_internal(send_internal),
        .translated_addr(translated_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send_external = 0;
            send_internal = 0;
            internal_addr = 0;
            external_addr = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Internal IP 0x0A -> External IP...", test_num);
            internal_addr = 8'h0A;
            send_internal = 1'b1;
            send_external = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h64);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Internal IP 0x0E -> External IP...", test_num);
            internal_addr = 8'h0E;
            send_internal = 1'b1;
            send_external = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h68);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: External IP 0x64 -> Internal IP...", test_num);
            external_addr = 8'h64;
            send_internal = 1'b0;
            send_external = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: External IP 0x67 -> Internal IP...", test_num);
            external_addr = 8'h67;
            send_internal = 1'b0;
            send_external = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h0D);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Unknown Internal IP (0xFF) -> Translation...", test_num);
            internal_addr = 8'hFF;
            send_internal = 1'b1;
            send_external = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Unknown External IP (0xAA) -> Translation...", test_num);
            external_addr = 8'hAA;
            send_internal = 1'b0;
            send_external = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_device Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_translated_addr;
        begin
            if (expected_translated_addr === (expected_translated_addr ^ translated_addr ^ expected_translated_addr)) begin
                $display("PASS");
                $display("  Outputs: translated_addr=%h",
                         translated_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_addr=%h",
                         expected_translated_addr);
                $display("  Got:      translated_addr=%h",
                         translated_addr);
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
        $dumpvars(0,clk, external_addr, internal_addr, reset, send_external, send_internal, translated_addr);
    end

endmodule
