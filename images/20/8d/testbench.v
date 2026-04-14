`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg valid;
    wire [31:0] data_out;
    wire packet_received;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .data_out(data_out),
        .packet_received(packet_received)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            valid = 0;
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic packet reception...");
            reset_dut();
            data_in = 32'hDEADBEEF;
            valid = 1;
            @(posedge clk);
            #1;
            valid = 0;
            data_in = 32'h0;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Data present but valid low...");
            reset_dut();
            data_in = 32'hCAFEBABE;
            valid = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Two consecutive packets...");
            reset_dut();

            data_in = 32'h11111111;
            valid = 1;
            @(posedge clk);
            #1;

            data_in = 32'h22222222;
            valid = 1;
            @(posedge clk);
            #1;
            valid = 0;
            #1;

            check_outputs(32'h22222222, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Reset mid-operation...");
            reset_dut();
            data_in = 32'hAAAAAAAA;
            valid = 1;
            @(posedge clk);
            #1;

            reset = 1;
            repeat (1) @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Boundary value (all ones)...");
            reset_dut();
            data_in = 32'hFFFFFFFF;
            valid = 1;
            @(posedge clk);
            #1;
            valid = 0;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Valid signal pulse width check...");
            reset_dut();
            data_in = 32'h12345678;
            valid = 1;
            @(posedge clk);
            #1;
            valid = 0;

            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input [31:0] expected_data_out;
        input expected_packet_received;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_packet_received === (expected_packet_received ^ packet_received ^ expected_packet_received)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, packet_received=%b",
                         data_out, packet_received);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, packet_received=%b",
                         expected_data_out, expected_packet_received);
                $display("  Got:      data_out=%h, packet_received=%b",
                         data_out, packet_received);
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
        $dumpvars(0,clk, data_in, reset, valid, data_out, packet_received);
    end

endmodule
