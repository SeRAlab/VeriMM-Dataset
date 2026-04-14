`timescale 1ns/1ps

module pcie_packet_checker_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] ctrl_in;
    reg [31:0] data_in;
    reg reset;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_packet_checker dut (
        .clk(clk),
        .ctrl_in(ctrl_in),
        .data_in(data_in),
        .reset(reset),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ctrl_in = 4'b0;
            data_in = 32'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Data Packet with non-zero data", test_num);
            reset_dut();
            ctrl_in = 4'b0000;
            data_in = 32'hABCD_1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Data Packet with zero data", test_num);
            reset_dut();
            ctrl_in = 4'b0000;
            data_in = 32'h0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Acknowledgment Packet with non-zero data", test_num);
            reset_dut();
            ctrl_in = 4'b0001;
            data_in = 32'h0000_0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Acknowledgment Packet with zero data", test_num);
            reset_dut();
            ctrl_in = 4'b0001;
            data_in = 32'h0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Error Packet with non-zero data", test_num);
            reset_dut();
            ctrl_in = 4'b0010;
            data_in = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reserved Control Signal (0011)", test_num);
            reset_dut();
            ctrl_in = 4'b0011;
            data_in = 32'h5555_AAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Reserved Control Signal (1111)", test_num);
            reset_dut();
            ctrl_in = 4'b1111;
            data_in = 32'h1234_5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Reset state validation", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_packet_checker Testbench");
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
        input expected_valid_out;
        begin
            if (expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: valid_out=%b",
                         valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_out=%b",
                         expected_valid_out);
                $display("  Got:      valid_out=%b",
                         valid_out);
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
        $dumpvars(0,clk, ctrl_in, data_in, reset, valid_out);
    end

endmodule
