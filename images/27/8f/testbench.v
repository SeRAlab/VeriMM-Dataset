`timescale 1ns/1ps

module pcie_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg packet_valid;
    reg rst;
    wire ack;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_receiver dut (
        .clk(clk),
        .data_in(data_in),
        .packet_valid(packet_valid),
        .rst(rst),
        .ack(ack),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            packet_valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Standard Valid Packet", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 32'hAAAA_BBBB;
            packet_valid = 1;

            @(posedge clk);
            packet_valid = 0;
            data_in = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Idle State (No packet_valid)", test_num);
            reset_dut();

            @(posedge clk);
            packet_valid = 0;
            data_in = 32'hFFFF_FFFF;

            repeat(3) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid Packet with Zero Data", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 32'h0000_0000;
            packet_valid = 1;

            @(posedge clk);
            packet_valid = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Back-to-back Packets", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 32'h1111_1111;
            packet_valid = 1;
            @(posedge clk);

            data_in = 32'h2222_2222;
            packet_valid = 1;
            @(posedge clk);

            packet_valid = 0;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Output Check Immediately After Reset", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0);
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
        input expected_ack;
        input expected_status;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, status=%b",
                         ack, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, status=%b",
                         expected_ack, expected_status);
                $display("  Got:      ack=%b, status=%b",
                         ack, status);
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
        $dumpvars(0,clk, data_in, packet_valid, rst, ack, status);
    end

endmodule
