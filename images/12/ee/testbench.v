`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command_type;
    reg [31:0] data_in;
    wire [31:0] data_out;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .command_type(command_type),
        .data_in(data_in),
        .data_out(data_out),
        .valid_output(valid_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            command_type = 2'b00;
            data_in = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Read Command");
            reset_dut();
            command_type = 2'b01;
            data_in = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Write Command");
            reset_dut();
            command_type = 2'b10;
            data_in = 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Invalidate Command");
            reset_dut();
            command_type = 2'b11;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Idle/No-op State");
            reset_dut();
            command_type = 2'b00;
            data_in = 32'hA5A5A5A5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Consecutive Read then Invalidate");
            reset_dut();


            command_type = 2'b01;
            data_in = 32'hCAFEFACE;
            @(posedge clk);
            #1;


            command_type = 2'b11;
            data_in = 32'h0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00000000, 1'b1);
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
        input expected_valid_output;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_output=%b",
                         data_out, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_output=%b",
                         expected_data_out, expected_valid_output);
                $display("  Got:      data_out=%h, valid_output=%b",
                         data_out, valid_output);
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
        $dumpvars(0,clk, command_type, data_in, data_out, valid_output);
    end

endmodule
