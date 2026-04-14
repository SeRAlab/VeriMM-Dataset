`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg read_req;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .address(address),
        .clk(clk),
        .read_req(read_req),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            read_req = 0;
            address = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Reading address 0x0");
            address = 4'h0;
            read_req = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
            read_req = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Reading address 0x5");
            address = 4'h5;
            read_req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h05);
            read_req = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Reading address 0xA");
            address = 4'hA;
            read_req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h0A);
            read_req = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Reading address 0xF");
            address = 4'hF;
            read_req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h0F);
            read_req = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Multi-cycle read stability for address 0x3");
            address = 4'h3;
            read_req = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h03);
            read_req = 0;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case 006: Assert read_req after address setup");
            address = 4'h7;
            #10;
            read_req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h07);
            read_req = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_controller Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,address, clk, read_req, data_out);
    end

endmodule
