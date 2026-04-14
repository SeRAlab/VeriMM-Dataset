`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_enable;
    reg reset;
    reg start;
    reg stop;
    reg [7:0] write_data;
    wire busy;
    wire done;
    wire [7:0] read_data;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .clk(clk),
        .read_enable(read_enable),
        .reset(reset),
        .start(start),
        .stop(stop),
        .write_data(write_data),
        .busy(busy),
        .done(done),
        .read_data(read_data),
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
            reset = 1;
            start = 0;
            stop = 0;
            read_enable = 0;
            write_data = 8'h00;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Start and Write Single Byte (0xA5)", test_num);
            reset_dut();

            @(posedge clk);
            write_data = 8'hA5;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);



            #1;




            check_outputs(0, 1, 8'h00, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Multi-byte Write (0x55, 0xAA)", test_num);
            reset_dut();


            @(posedge clk);
            write_data = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            #10;


            @(posedge clk);
            write_data = 8'hAA;
            @(posedge clk);
            wait(done);
            @(posedge clk);

            #1;


            check_outputs(0, 1, 8'h00, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Read Data Operation", test_num);
            reset_dut();

            @(posedge clk);
            read_enable = 1;
            start = 1;
            @(posedge clk);
            start = 0;



            wait(done);
            @(posedge clk);



            #1;




            check_outputs(0, 1, read_data, 1, 1);
            read_enable = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Stop Condition Generation", test_num);
            reset_dut();


            @(posedge clk);
            write_data = 8'h12;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);

            #20;
            @(posedge clk);
            stop = 1;
            @(posedge clk);
            stop = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(0, 1, 8'h00, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Full Transaction (Start-Write-Stop)", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            write_data = 8'h33;
            @(posedge clk);
            start = 0;

            wait(done);

            @(posedge clk);
            stop = 1;
            @(posedge clk);
            stop = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(0, 1, 8'h00, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: 8-Byte Burst Write", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                write_data = i;
                if (i == 0) start = 1;
                else start = 0;

                @(posedge clk);
                start = 0;
                wait(done);
                #10;
            end

            @(posedge clk);
            stop = 1;
            @(posedge clk);
            stop = 0;
            wait(done);

            #1;


            check_outputs(0, 1, 8'h00, 1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
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
        input expected_busy;
        input expected_done;
        input [7:0] expected_read_data;
        input expected_scl;
        input expected_sda;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, done=%b, read_data=%h, scl=%b, sda=%b",
                         busy, done, read_data, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, done=%b, read_data=%h, scl=%b, sda=%b",
                         expected_busy, expected_done, expected_read_data, expected_scl, expected_sda);
                $display("  Got:      busy=%b, done=%b, read_data=%h, scl=%b, sda=%b",
                         busy, done, read_data, scl, sda);
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
        $dumpvars(0,clk, read_enable, reset, start, stop, write_data, busy, done, read_data, scl, sda);
    end

endmodule
