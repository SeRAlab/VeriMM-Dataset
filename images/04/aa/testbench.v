`timescale 1ns/1ps

module pcie_packet_parser_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] pcie_packet;
    reg rst;
    wire [31:0] address;
    wire [15:0] req_id;
    wire [7:0] tlp_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_packet_parser dut (
        .clk(clk),
        .pcie_packet(pcie_packet),
        .rst(rst),
        .address(address),
        .req_id(req_id),
        .tlp_type(tlp_type)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pcie_packet = 128'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Standard Memory Read Pattern");
            reset_dut();
            pcie_packet = {8'h4A, 16'h1234, 32'hDEADBEEF, 72'h0};
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 16'h1234, 8'h4A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Configuration Write Pattern");
            reset_dut();
            pcie_packet = {8'h0F, 16'hABCD, 32'h12345678, 72'hFFFFFFFF};
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678, 16'hABCD, 8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: All Zeros");
            reset_dut();
            pcie_packet = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 16'h0000, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: All Ones in Header Fields");
            reset_dut();
            pcie_packet = {8'hFF, 16'hFFFF, 32'hFFFFFFFF, 72'h0};
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 16'hFFFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Alternating Bit Pattern");
            reset_dut();
            pcie_packet = {8'hAA, 16'h5555, 32'hAAAA5555, 72'h5555AAAA};
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAA5555, 16'h5555, 8'hAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_packet_parser Testbench");
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
        input [31:0] expected_address;
        input [15:0] expected_req_id;
        input [7:0] expected_tlp_type;
        begin
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_req_id === (expected_req_id ^ req_id ^ expected_req_id) &&
                expected_tlp_type === (expected_tlp_type ^ tlp_type ^ expected_tlp_type)) begin
                $display("PASS");
                $display("  Outputs: address=%h, req_id=%h, tlp_type=%h",
                         address, req_id, tlp_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, req_id=%h, tlp_type=%h",
                         expected_address, expected_req_id, expected_tlp_type);
                $display("  Got:      address=%h, req_id=%h, tlp_type=%h",
                         address, req_id, tlp_type);
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
        $dumpvars(0,clk, pcie_packet, rst, address, req_id, tlp_type);
    end

endmodule
