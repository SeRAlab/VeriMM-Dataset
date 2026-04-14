`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg rw;
    wire ACK;
    wire SCL;
    wire SDA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .rw(rw),
        .ACK(ACK),
        .SCL(SCL),
        .SDA(SDA)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            data_in = 8'h00;
            rw = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Data Write 0x55", test_num);
            reset_dut();

            data_in = 8'h55;
            rw = 0;
            enable = 1;
            @(posedge clk);
            enable = 0;



            repeat(2000) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Data Write 0xAA", test_num);
            reset_dut();

            data_in = 8'hAA;
            rw = 0;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(2000) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data Read Operation", test_num);
            reset_dut();

            data_in = 8'h00;
            rw = 1;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(2000) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data Write 0x00", test_num);
            reset_dut();

            data_in = 8'h00;
            rw = 0;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(2000) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data Write 0xFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            rw = 0;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(2000) @(posedge clk);
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
        $display("i2c_controller Testbench");
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
        input expected_ACK;
        input expected_SCL;
        input expected_SDA;
        begin
            if (expected_ACK === (expected_ACK ^ ACK ^ expected_ACK) &&
                expected_SCL === (expected_SCL ^ SCL ^ expected_SCL) &&
                expected_SDA === (expected_SDA ^ SDA ^ expected_SDA)) begin
                $display("PASS");
                $display("  Outputs: ACK=%b, SCL=%b, SDA=%b",
                         ACK, SCL, SDA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACK=%b, SCL=%b, SDA=%b",
                         expected_ACK, expected_SCL, expected_SDA);
                $display("  Got:      ACK=%b, SCL=%b, SDA=%b",
                         ACK, SCL, SDA);
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
        $dumpvars(0,clk, data_in, enable, rw, ACK, SCL, SDA);
    end

endmodule
