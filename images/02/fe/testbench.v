`timescale 1ns/1ps

module i2c_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    reg stop;
    wire ack;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_master dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .stop(stop),
        .ack(ack),
        .scl(scl),
        .sda(sda)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            stop = 0;
            data_in = 8'h0;
            @(posedge clk);



            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Transmission of 0xAA");
            reset_dut();

            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            start = 0;



            repeat(200) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(20) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Transmission of 0x55");
            reset_dut();

            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(200) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Transmission of 0x00");
            reset_dut();

            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(200) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Transmission of 0xFF");
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(200) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Repeated Start Simulation");
            reset_dut();


            data_in = 8'h12;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(180) @(posedge clk);


            data_in = 8'h34;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(180) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_master Testbench");
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
        input expected_scl;
        input expected_sda;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, scl=%b, sda=%b",
                         ack, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, scl=%b, sda=%b",
                         expected_ack, expected_scl, expected_sda);
                $display("  Got:      ack=%b, scl=%b, sda=%b",
                         ack, scl, sda);
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
        $dumpvars(0,clk, data_in, start, stop, ack, scl, sda);
    end

endmodule
