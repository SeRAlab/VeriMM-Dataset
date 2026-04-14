`timescale 1ns/1ps

module cache_lru_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg read;
    reg reset;
    reg [7:0] write_data;
    reg write_enable;
    wire hit;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_lru dut (
        .address(address),
        .clk(clk),
        .read(read),
        .reset(reset),
        .write_data(write_data),
        .write_enable(write_enable),
        .hit(hit),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 0;
            read = 0;
            write_enable = 0;
            write_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            address = 4'hA;
            write_data = 8'h55;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;

            read = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'h55);
            read = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            address = 4'h0; write_data = 8'h11; write_enable = 1; @(posedge clk);
            address = 4'h2; write_data = 8'h22; write_enable = 1; @(posedge clk);
            write_enable = 0;

            address = 4'h0; read = 1; @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'h11);
            read = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            address = 4'h0; write_data = 8'hA1; write_enable = 1; @(posedge clk);
            address = 4'h2; write_data = 8'hA2; write_enable = 1; @(posedge clk);
            write_enable = 0;

            address = 4'h0; read = 1; @(posedge clk);
            read = 0; @(posedge clk);

            address = 4'h4; write_data = 8'hA3; write_enable = 1; @(posedge clk);
            write_enable = 0;

            address = 4'h2; read = 1; @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'h00);
            read = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            address = 4'h5; write_data = 8'hAA; write_enable = 1; @(posedge clk);

            address = 4'h5; write_data = 8'hBB; write_enable = 1; @(posedge clk);
            write_enable = 0;

            address = 4'h5; read = 1; @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'hBB);
            read = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            address = 4'h1; write_data = 8'hD1; write_enable = 1; @(posedge clk);

            address = 4'h0; write_data = 8'hE0; write_enable = 1; @(posedge clk);
            address = 4'h2; write_data = 8'hE2; write_enable = 1; @(posedge clk);
            address = 4'h4; write_data = 8'hE4; write_enable = 1; @(posedge clk);
            write_enable = 0;

            address = 4'h1; read = 1; @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'hD1);
            read = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_lru Testbench");
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
        input expected_hit;
        input [7:0] expected_read_data;
        begin
            if (expected_hit === (expected_hit ^ hit ^ expected_hit) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: hit=%b, read_data=%h",
                         hit, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hit=%b, read_data=%h",
                         expected_hit, expected_read_data);
                $display("  Got:      hit=%b, read_data=%h",
                         hit, read_data);
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
        $dumpvars(0,address, clk, read, reset, write_data, write_enable, hit, read_data);
    end

endmodule
