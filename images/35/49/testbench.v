`timescale 1ns/1ps

module pcie_packet_checker_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] packet_data;
    reg rst_n;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_packet_checker dut (
        .clk(clk),
        .packet_data(packet_data),
        .rst_n(rst_n),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            packet_data = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        reg [127:0] p;
        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Valid Packet", test_num);
            p[127:120] = 8'h5A;
            p[119:112] = 8'h10;
            p[111:8]   = 104'hDEADBEEFCAFEBABE1234567890;
            p[7:0]     = calc_checksum(p[127:8]);

            packet_data = p;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        reg [127:0] p;
        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Invalid Header", test_num);
            p[127:120] = 8'hA5;
            p[119:112] = 8'h10;
            p[111:8]   = 104'h1;
            p[7:0]     = calc_checksum(p[127:8]);

            packet_data = p;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        reg [127:0] p;
        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Length Exceeds Max (Assume Max=16)", test_num);
            p[127:120] = 8'h5A;
            p[119:112] = 8'hFF;
            p[111:8]   = 104'hABC;
            p[7:0]     = calc_checksum(p[127:8]);

            packet_data = p;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        reg [127:0] p;
        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Invalid Checksum", test_num);
            p[127:120] = 8'h5A;
            p[119:112] = 8'h10;
            p[111:8]   = 104'hCAFE;
            p[7:0]     = calc_checksum(p[127:8]) ^ 8'hFF;

            packet_data = p;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: All Zeros Packet", test_num);
            packet_data = 128'h0;
            repeat(2) @(posedge clk);
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
        input expected_valid;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: valid=%b",
                         valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b",
                         expected_valid);
                $display("  Got:      valid=%b",
                         valid);
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
        $dumpvars(0,clk, packet_data, rst_n, valid);
    end

endmodule
