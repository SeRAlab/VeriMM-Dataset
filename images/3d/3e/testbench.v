`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg command;
    reg [31:0] data_in;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .address(address),
        .clk(clk),
        .command(command),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            command = 0;
            data_in = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Write and Read at Address 5");
            reset_dut();


            command = 1;
            address = 4'h5;
            data_in = 32'hDEADBEEF;
            @(posedge clk);
            #1;


            command = 0;
            address = 4'h5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Write and Read at Address 15");
            reset_dut();


            command = 1;
            address = 4'hF;
            data_in = 32'h12345678;
            @(posedge clk);
            #1;


            command = 0;
            address = 4'hF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Overwrite Data at Address 0");
            reset_dut();


            command = 1;
            address = 4'h0;
            data_in = 32'hAAAAAAAA;
            @(posedge clk);
            #1;


            data_in = 32'hBBBBBBBB;
            @(posedge clk);
            #1;


            command = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hBBBBBBBB);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Verifying Data Independence (Addr 1 vs Addr 2)");
            reset_dut();


            command = 1;
            address = 4'h1;
            data_in = 32'h11111111;
            @(posedge clk);
            #1;


            address = 4'h2;
            data_in = 32'h22222222;
            @(posedge clk);
            #1;


            command = 0;
            address = 4'h1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h11111111);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Read Address 9 (Uninitialized Check)");
            reset_dut();

            command = 0;
            address = 4'h9;
            @(posedge clk);
            #1;



            #1;




            check_outputs(32'h00000000);
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,address, clk, command, data_in, data_out);
    end

endmodule
