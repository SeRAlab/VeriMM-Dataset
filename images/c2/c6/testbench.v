`timescale 1ns/1ps

module memory_controller_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addr;
    reg clk;
    reg [15:0] din;
    reg rst;
    reg we;
    wire ack;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_controller dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .rst(rst),
        .we(we),
        .ack(ack),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr = 0;
            we = 0;
            din = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Synchronous Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Simple Write and Read");
            reset_dut();


            addr = 12'h0A0;
            din = 16'hABCD;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'hABCD);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Boundary Address Check (0xFFF)");
            reset_dut();


            addr = 12'hFFF;
            din = 16'h55AA;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'h55AA);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Data Persistence Across Different Addresses");
            reset_dut();


            addr = 12'h100;
            din = 16'h1111;
            we = 1;
            @(posedge clk);
            #1;


            addr = 12'h200;
            din = 16'h2222;
            we = 1;
            @(posedge clk);
            #1;


            addr = 12'h100;
            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'h1111);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Overwrite Data at same address");
            reset_dut();


            addr = 12'h300;
            din = 16'hAAAA;
            we = 1;
            @(posedge clk);
            #1;


            din = 16'hBBBB;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'hBBBB);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Reset during operation");
            reset_dut();


            addr = 12'h400;
            din = 16'h1234;
            we = 1;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(1'b0, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_controller Testbench");
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
        input expected_ack;
        input [15:0] expected_dout;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, dout=%h",
                         ack, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, dout=%h",
                         expected_ack, expected_dout);
                $display("  Got:      ack=%b, dout=%h",
                         ack, dout);
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
        $dumpvars(0,addr, clk, din, rst, we, ack, dout);
    end

endmodule
