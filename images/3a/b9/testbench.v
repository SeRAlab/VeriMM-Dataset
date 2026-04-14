`timescale 1ns/1ps

module pcie_receiver_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr_in;
    reg clk;
    reg [31:0] data_in;
    reg output_enable;
    reg valid;
    wire [2:0] addr_out;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_receiver dut (
        .addr_in(addr_in),
        .clk(clk),
        .data_in(data_in),
        .output_enable(output_enable),
        .valid(valid),
        .addr_out(addr_out),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            valid = 0;
            output_enable = 0;
            addr_in = 0;
            data_in = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Latch and Read", test_num);
            reset_dut();

            addr_in = 3'h3;
            data_in = 32'hABCDEF01;
            valid = 1;
            @(posedge clk);
            #1;
            valid = 0;
            output_enable = 1;
            #1;
            #1;

            check_outputs(3'h3, 32'hABCDEF01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid Signal Requirement", test_num);
            reset_dut();


            addr_in = 3'h1;
            data_in = 32'h11111111;
            valid = 1;
            @(posedge clk);
            #1;


            addr_in = 3'h7;
            data_in = 32'hEEEEEEEE;
            valid = 0;
            @(posedge clk);
            #1;

            output_enable = 1;
            #1;

            #1;


            check_outputs(3'h1, 32'h11111111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Output Enable Toggle", test_num);
            reset_dut();

            addr_in = 3'h5;
            data_in = 32'h55AA55AA;
            valid = 1;
            @(posedge clk);
            #1;
            valid = 0;

            output_enable = 0;
            #10;
            output_enable = 1;
            #1;
            #1;

            check_outputs(3'h5, 32'h55AA55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Retention", test_num);
            reset_dut();

            addr_in = 3'h2;
            data_in = 32'hDEADBEEF;
            valid = 1;
            @(posedge clk);
            #1;

            valid = 0;
            addr_in = 3'h0;
            data_in = 32'h0;
            @(posedge clk);
            #1;

            output_enable = 1;
            #1;
            #1;

            check_outputs(3'h2, 32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Values", test_num);
            reset_dut();

            addr_in = 3'h7;
            data_in = 32'hFFFFFFFF;
            valid = 1;
            @(posedge clk);
            #1;

            output_enable = 1;
            valid = 0;
            #1;
            #1;

            check_outputs(3'h7, 32'hFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_receiver Testbench");
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
        input [2:0] expected_addr_out;
        input [31:0] expected_data_out;
        begin
            if (expected_addr_out === (expected_addr_out ^ addr_out ^ expected_addr_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: addr_out=%h, data_out=%h",
                         addr_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_out=%h, data_out=%h",
                         expected_addr_out, expected_data_out);
                $display("  Got:      addr_out=%h, data_out=%h",
                         addr_out, data_out);
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
        $dumpvars(0,addr_in, clk, data_in, output_enable, valid, addr_out, data_out);
    end

endmodule
