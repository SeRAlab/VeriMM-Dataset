`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read_req;
    reg rst_n;
    reg write_req;
    wire [7:0] data_out;
    wire read_ack;
    wire write_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .data_in(data_in),
        .read_req(read_req),
        .rst_n(rst_n),
        .write_req(write_req),
        .data_out(data_out),
        .read_ack(read_ack),
        .write_ack(write_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            read_req = 0;
            write_req = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: System Reset State");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Simple Write Operation");
            test_num = 2;
            reset_dut();

            @(posedge clk);
            write_req = 1;
            data_in = 8'hAA;
            @(posedge clk);
            write_req = 0;


            @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Write followed by Read");
            test_num = 3;
            reset_dut();


            @(posedge clk);
            write_req = 1;
            data_in = 8'h55;
            @(posedge clk);
            write_req = 0;
            @(posedge clk);


            @(posedge clk);
            read_req = 1;
            @(posedge clk);
            read_req = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Consecutive Writes");
            test_num = 4;
            reset_dut();


            @(posedge clk);
            write_req = 1;
            data_in = 8'h11;
            @(posedge clk);


            data_in = 8'h22;
            @(posedge clk);
            write_req = 0;
            @(posedge clk);


            read_req = 1;
            @(posedge clk);
            read_req = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h22, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Read after Reset");
            test_num = 5;
            reset_dut();

            @(posedge clk);
            read_req = 1;
            @(posedge clk);
            read_req = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Simultaneous Read/Write");
            test_num = 6;
            reset_dut();

            @(posedge clk);
            write_req = 1;
            read_req = 1;
            data_in = 8'hCC;
            @(posedge clk);
            write_req = 0;
            read_req = 0;
            @(posedge clk);



            if (read_ack || write_ack) begin
                $display("Simultaneous access handled. read_ack: %b, write_ack: %b", read_ack, write_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: No acknowledgement on simultaneous request.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_read_ack;
        input expected_write_ack;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_read_ack === (expected_read_ack ^ read_ack ^ expected_read_ack) &&
                expected_write_ack === (expected_write_ack ^ write_ack ^ expected_write_ack)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, read_ack=%b, write_ack=%b",
                         data_out, read_ack, write_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, read_ack=%b, write_ack=%b",
                         expected_data_out, expected_read_ack, expected_write_ack);
                $display("  Got:      data_out=%h, read_ack=%b, write_ack=%b",
                         data_out, read_ack, write_ack);
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
        $dumpvars(0,clk, data_in, read_req, rst_n, write_req, data_out, read_ack, write_ack);
    end

endmodule
