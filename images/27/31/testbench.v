`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [31:0] local_ip;
    reg [15:0] local_port;
    reg reset;
    wire [31:0] public_ip;
    wire [15:0] public_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .control(control),
        .local_ip(local_ip),
        .local_port(local_port),
        .reset(reset),
        .public_ip(public_ip),
        .public_port(public_port)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            local_ip = 32'h0;
            local_port = 16'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Translation - Mapping 1", test_num);


            local_ip = 32'hC0A80101;
            local_port = 16'd80;
            control = 1;

            @(posedge clk);
            #1;



            #1;




            check_outputs(32'h01020304, 16'd8080);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Basic Translation - Mapping 2", test_num);

            local_ip = 32'hC0A80102;
            local_port = 16'd443;
            control = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h01020305, 16'd8443);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Basic Translation - Mapping 3", test_num);

            local_ip = 32'h0A000005;
            local_port = 16'd22;
            control = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h01020306, 16'd2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Control signal de-asserted", test_num);

            local_ip = 32'hC0A80101;
            local_port = 16'd80;
            control = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 16'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Unknown local address mapping", test_num);

            local_ip = 32'hFFFFFFFF;
            local_port = 16'hFFFF;
            control = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 16'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Translation immediately after reset", test_num);

            local_ip = 32'hC0A80101;
            local_port = 16'd80;
            control = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h01020304, 16'd8080);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT Testbench");
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
        input [31:0] expected_public_ip;
        input [15:0] expected_public_port;
        begin
            if (expected_public_ip === (expected_public_ip ^ public_ip ^ expected_public_ip) &&
                expected_public_port === (expected_public_port ^ public_port ^ expected_public_port)) begin
                $display("PASS");
                $display("  Outputs: public_ip=%h, public_port=%h",
                         public_ip, public_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: public_ip=%h, public_port=%h",
                         expected_public_ip, expected_public_port);
                $display("  Got:      public_ip=%h, public_port=%h",
                         public_ip, public_port);
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
        $dumpvars(0,clk, control, local_ip, local_port, reset, public_ip, public_port);
    end

endmodule
