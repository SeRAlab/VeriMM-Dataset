`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire CS;
    wire MOSI;
    wire SCK;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .CS(CS),
        .MOSI(MOSI),
        .SCK(SCK),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data_in = 8'h00;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Transmitting single byte 8'hA5", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);
            @(posedge clk);





            #1;






            check_outputs(1, MOSI, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transmitting single byte 8'h00", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transmitting single byte 8'hFF", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Transmitting two consecutive bytes (0x55 then 0xAA)", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);


            #50;


            @(posedge clk);
            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1, MOSI, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying reset behavior during transmission", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(CS == 0);
            #30;


            rst = 1;
            #20;
            rst = 0;
            #10;



            #1;




            check_outputs(1, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master Testbench");
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
        input expected_CS;
        input expected_MOSI;
        input expected_SCK;
        input expected_done;
        begin
            if (expected_CS === (expected_CS ^ CS ^ expected_CS) &&
                expected_MOSI === (expected_MOSI ^ MOSI ^ expected_MOSI) &&
                expected_SCK === (expected_SCK ^ SCK ^ expected_SCK) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: CS=%b, MOSI=%b, SCK=%b, done=%b",
                         CS, MOSI, SCK, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CS=%b, MOSI=%b, SCK=%b, done=%b",
                         expected_CS, expected_MOSI, expected_SCK, expected_done);
                $display("  Got:      CS=%b, MOSI=%b, SCK=%b, done=%b",
                         CS, MOSI, SCK, done);
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
        $dumpvars(0,clk, data_in, rst, start, CS, MOSI, SCK, done);
    end

endmodule
