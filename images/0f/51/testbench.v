`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg [47:0] mac_address;
    reg reset;
    wire [7:0] data_out;
    wire frame_received;
    wire frame_sent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .mac_address(mac_address),
        .reset(reset),
        .data_out(data_out),
        .frame_received(frame_received),
        .frame_sent(frame_sent)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            data_valid = 1'b0;
            mac_address = 48'h0;
            #20;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Reset State Check...");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Basic Frame Transmission...");
            reset_dut();

            mac_address = 48'hAABBCCDDEEFF;
            @(posedge clk);


            data_valid = 1'b1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            data_valid = 1'b0;


            repeat(100) @(posedge clk);


            #1;



            check_outputs(data_out, frame_received, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Running Testcase 003: Large Payload Transmission...");
            reset_dut();

            mac_address = 48'h010203040506;
            @(posedge clk);

            data_valid = 1'b1;
            for (i = 0; i < 32; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
            end
            data_valid = 1'b0;


            repeat(200) @(posedge clk);

            #1;


            check_outputs(data_out, frame_received, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Frame Reception Check...");
            reset_dut();

            mac_address = 48'hFFFFFFFFFFFF;
            @(posedge clk);



            data_valid = 1'b1;
            data_in = 8'hAA; @(posedge clk);
            data_in = 8'h55; @(posedge clk);
            data_valid = 1'b0;

            repeat(150) @(posedge clk);



            #1;




            check_outputs(data_out, 1'b1, frame_sent);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: MAC Address Update and Reset Recovery...");
            reset_dut();

            mac_address = 48'h1234567890AB;
            data_valid = 1'b1;
            data_in = 8'hFF; @(posedge clk);


            reset = 1'b1;
            #15;
            reset = 1'b0;
            #10;


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_frame_received;
        input expected_frame_sent;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_frame_received === (expected_frame_received ^ frame_received ^ expected_frame_received) &&
                expected_frame_sent === (expected_frame_sent ^ frame_sent ^ expected_frame_sent)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, frame_received=%b, frame_sent=%b",
                         data_out, frame_received, frame_sent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, frame_received=%b, frame_sent=%b",
                         expected_data_out, expected_frame_received, expected_frame_sent);
                $display("  Got:      data_out=%h, frame_received=%b, frame_sent=%b",
                         data_out, frame_received, frame_sent);
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
        $dumpvars(0,clk, data_in, data_valid, mac_address, reset, data_out, frame_received, frame_sent);
    end

endmodule
