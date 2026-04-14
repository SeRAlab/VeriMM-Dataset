`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Args;
    reg [6:0] CRC;
    reg Clk;
    reg CmdSend;
    reg [5:0] Command;
    reg SendAck;
    wire CmdAck;
    wire [7:0] SendData;
    wire SendReq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Args(Args),
        .CRC(CRC),
        .Clk(Clk),
        .CmdSend(CmdSend),
        .Command(Command),
        .SendAck(SendAck),
        .CmdAck(CmdAck),
        .SendData(SendData),
        .SendReq(SendReq)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Args = 32'h0;
            CRC = 7'h0;
            CmdSend = 1'b0;
            Command = 6'h0;
            SendAck = 1'b0;
            @(posedge Clk);
            #1;
        end
        endtask
    task simulate_byte_handshake;

        input integer num_bytes;
        integer i;
        begin
            for (i = 0; i < num_bytes; i = i + 1) begin

                while (!SendReq) @(posedge Clk);


                @(posedge Clk);
                SendAck = 1;


                @(posedge Clk);
                SendAck = 0;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Standard Command Transmission", test_num);
            reset_dut();


            Command = 6'h11;
            Args = 32'h12345678;
            CRC = 7'h45;

            @(posedge Clk);
            CmdSend = 1;
            @(posedge Clk);
            CmdSend = 0;


            simulate_byte_handshake(6);


            while (!CmdAck) @(posedge Clk);




            #1;





            check_outputs(1, 8'h8B, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: All-Zero Transmission", test_num);
            reset_dut();

            Command = 6'h00;
            Args = 32'h00000000;
            CRC = 7'h00;

            @(posedge Clk);
            CmdSend = 1;
            @(posedge Clk);
            CmdSend = 0;

            simulate_byte_handshake(6);

            while (!CmdAck) @(posedge Clk);


            #1;



            check_outputs(1, 8'h01, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: All-Ones Transmission", test_num);
            reset_dut();

            Command = 6'h3F;
            Args = 32'hFFFFFFFF;
            CRC = 7'h7F;

            @(posedge Clk);
            CmdSend = 1;
            @(posedge Clk);
            CmdSend = 0;

            simulate_byte_handshake(6);

            while (!CmdAck) @(posedge Clk);


            #1;



            check_outputs(1, 8'hFF, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Alternating Bit Pattern Transmission", test_num);
            reset_dut();

            Command = 6'h2A;
            Args = 32'hAAAAAAAA;
            CRC = 7'h55;

            @(posedge Clk);
            CmdSend = 1;
            @(posedge Clk);
            CmdSend = 0;

            simulate_byte_handshake(6);

            while (!CmdAck) @(posedge Clk);


            #1;



            check_outputs(1, 8'hAB, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_CmdAck;
        input [7:0] expected_SendData;
        input expected_SendReq;
        begin
            if (expected_CmdAck === (expected_CmdAck ^ CmdAck ^ expected_CmdAck) &&
                expected_SendData === (expected_SendData ^ SendData ^ expected_SendData) &&
                expected_SendReq === (expected_SendReq ^ SendReq ^ expected_SendReq)) begin
                $display("PASS");
                $display("  Outputs: CmdAck=%b, SendData=%h, SendReq=%b",
                         CmdAck, SendData, SendReq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CmdAck=%b, SendData=%h, SendReq=%b",
                         expected_CmdAck, expected_SendData, expected_SendReq);
                $display("  Got:      CmdAck=%b, SendData=%h, SendReq=%b",
                         CmdAck, SendData, SendReq);
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
        $dumpvars(0,Args, CRC, Clk, CmdSend, Command, SendAck, CmdAck, SendData, SendReq);
    end

endmodule
