`timescale 1ns/1ps

module PacketFilter_tb;

    // Testbench signals (sequential circuit)
    reg accept_packet;
    reg clk;
    reg [4:0] packet_in;
    reg reset;
    wire packet_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PacketFilter dut (
        .accept_packet(accept_packet),
        .clk(clk),
        .packet_in(packet_in),
        .reset(reset),
        .packet_out(packet_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            accept_packet = 0;
            packet_in = 5'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matching pattern (10101) with accept_packet=1", test_num);
            reset_dut();
            packet_in = 5'b10101;
            accept_packet = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matching pattern (10101) with accept_packet=0", test_num);
            reset_dut();
            packet_in = 5'b10101;
            accept_packet = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mismatch pattern (00000) with accept_packet=1", test_num);
            reset_dut();
            packet_in = 5'b00000;
            accept_packet = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mismatch pattern (11111) with accept_packet=1", test_num);
            reset_dut();
            packet_in = 5'b11111;
            accept_packet = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Near-match pattern (10100) with accept_packet=1", test_num);
            reset_dut();
            packet_in = 5'b10100;
            accept_packet = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: System state immediately after reset", test_num);
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
        $display("PacketFilter Testbench");
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
        input expected_packet_out;
        begin
            if (expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out)) begin
                $display("PASS");
                $display("  Outputs: packet_out=%b",
                         packet_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_out=%b",
                         expected_packet_out);
                $display("  Got:      packet_out=%b",
                         packet_out);
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
        $dumpvars(0,accept_packet, clk, packet_in, reset, packet_out);
    end

endmodule
