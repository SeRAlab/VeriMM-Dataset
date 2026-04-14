`timescale 1ns/1ps

module eth_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire ack_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .ack_out(ack_out)
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
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Standard 8-byte packet", test_num);
            reset_dut();


            data_in = 8'h55; @(posedge clk);
            data_in = 8'hAA; @(posedge clk);
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            data_in = 8'h55; @(posedge clk);
            data_in = 8'h66; @(posedge clk);

            data_in = 8'h00;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum 1-byte packet", test_num);
            reset_dut();

            data_in = 8'hFF; @(posedge clk);
            data_in = 8'h00;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Verification", test_num);

            reset = 1;
            data_in = 8'hAA;
            repeat(3) @(posedge clk);


            #1;



            check_outputs(1'b0);

            #1 reset = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data during reset (No Ack Expected)", test_num);
            reset_dut();

            reset = 1;
            data_in = 8'hDE; @(posedge clk);
            data_in = 8'hAD; @(posedge clk);
            data_in = 8'hBE; @(posedge clk);
            data_in = 8'hEF; @(posedge clk);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
            #1 reset = 0;
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Long packet (16 bytes)", test_num);
            reset_dut();

            for(i = 0; i < 16; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
            end

            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Idle lines (Zero data)", test_num);
            reset_dut();

            data_in = 8'h00;
            repeat(5) @(posedge clk);



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
        $display("eth_mac_controller Testbench");
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
        input expected_ack_out;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b",
                         ack_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b",
                         expected_ack_out);
                $display("  Got:      ack_out=%b",
                         ack_out);
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
        $dumpvars(0,clk, data_in, reset, ack_out);
    end

endmodule
